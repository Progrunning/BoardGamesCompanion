import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/results/board_game_creation_result.dart';
import '../../widgets/board_games/bgc_flexible_space_bar.dart';
import '../../widgets/common/board_game/collection_flags.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/section_header.dart';
import 'create_board_game_view_model.dart';
import 'create_board_game_visual_states.dart';

class CreateBoardGamePage extends StatefulWidget {
  const CreateBoardGamePage({
    super.key,
    required this.viewModel,
  });

  static const String pageRoute = '/createBoardGame';

  final CreateBoardGameViewModel viewModel;

  @override
  State<CreateBoardGamePage> createState() => _CreateBoardGamePageState();
}

class _CreateBoardGamePageState extends State<CreateBoardGamePage> {
  final boardGameNameController = TextEditingController();
  final imagePicker = ImagePicker();

  late ReactionDisposer _visualStateReactionDisposer;

  @override
  void initState() {
    super.initState();
    boardGameNameController.text = widget.viewModel.boardGame.name;
    boardGameNameController.addListener(() {
      widget.viewModel.setBoardGameName(boardGameNameController.text);
    });

    _visualStateReactionDisposer = reaction((_) => widget.viewModel.visualState,
        (CreateBoardGamePageVisualStates visualState) {
      final navigatorState = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      visualState.maybeWhen(
        removingFromCollectionsSucceeded: (boardGameName) => navigatorState.pop(
          GameCreationResult.removingFromCollectionsSucceeded(
            boardGameName: widget.viewModel.boardGame.name,
          ),
        ),
        saveSuccess: () => navigatorState.pop(
          GameCreationResult.saveSuccess(
            boardGameId: widget.viewModel.boardGame.id,
            boardGameName: widget.viewModel.boardGame.name,
          ),
        ),
        saveFailure: () => _showSaveFailureSnackbar(messenger),
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    boardGameNameController.dispose();
    _visualStateReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => _handleOnWillPop(),
        child: Scaffold(
          body: SafeArea(
            child: PageContainer(
              child: Form(
                child: CustomScrollView(
                  slivers: [
                    Observer(
                      builder: (_) {
                        return _Header(
                          boardGameName: widget.viewModel.boardGame.name,
                          boardGameImageUri: widget.viewModel.boardGame.imageUrl,
                          onPop: () => Navigator.maybePop(context),
                        );
                      },
                    ),
                    _Form(
                      viewModel: widget.viewModel,
                      boardGameNameController: boardGameNameController,
                      onToggleCollection: (collectionType) =>
                          widget.viewModel.toggleCollection(collectionType),
                      onPickImage: (imageSource) =>
                          _handlePickingAndSavingBoardGameImage(imageSource),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Observer(
            builder: (_) {
              return FloatingActionButton(
                onPressed: widget.viewModel.isValid ? () async => _saveBoardGame() : null,
                backgroundColor: widget.viewModel.isValid
                    ? AppColors.accentColor
                    : AppColors.disabledFloatinActionButtonColor,
                child: widget.viewModel.visualState.maybeWhen(
                  orElse: () => const Icon(Icons.save),
                  saving: () => const CircularProgressIndicator(color: AppColors.primaryColor),
                ),
              );
            },
          ),
        ),
      );

  Future<bool> _handleOnWillPop() async {
    if (widget.viewModel.hasUnsavedChanges) {
      final shouldNavigateAway = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(AppText.createNewGameUnsavedChangesDialogTitle),
            content: const Text(AppText.createNewGameUnsavedChangesDialogContent),
            elevation: Dimensions.defaultElevation,
            actions: <Widget>[
              TextButton(
                child: const Text(AppText.cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  AppText.navigateAway,
                  style: TextStyle(color: AppColors.defaultTextColor),
                ),
              ),
            ],
          );
        },
      );

      return shouldNavigateAway ?? true;
    }

    return true;
  }

  Future<void> _handlePickingAndSavingBoardGameImage(ImageSource imageSource) async {
    final boardGameImageFile = await imagePicker.pickImage(source: imageSource);
    if (boardGameImageFile?.path.isEmpty ?? true) {
      return;
    }

    widget.viewModel.updateImage(boardGameImageFile!);
  }

  Future<void> _saveBoardGame() async {
    if (!widget.viewModel.isInAnyCollection) {
      final shouldRemoveFromCollections = await _showRemoveGameFromAllCollectionsDialog(context);
      if (!(shouldRemoveFromCollections ?? false)) {
        return;
      }
    }

    await widget.viewModel.saveBoardGame();
  }

  Future<void> _showSaveFailureSnackbar(ScaffoldMessengerState messenger) async {
    messenger.showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: Text(AppText.createNewGameSavingFailedText),
        duration: Duration(seconds: 10),
      ),
    );
  }

  Future<bool?> _showRemoveGameFromAllCollectionsDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppText.createNewGameRemoveFromCollectionConfirmationDialogTitle),
          content: Text(
            sprintf(
              AppText.createNewGameRemoveFromCollectionConfirmationDialogContentFormat,
              [
                widget.viewModel.boardGame.name,
              ],
            ),
          ),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                AppText.remove,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
    required this.viewModel,
    required this.boardGameNameController,
    required this.onToggleCollection,
    required this.onPickImage,
  }) : super(key: key);

  final CreateBoardGameViewModel viewModel;
  final TextEditingController boardGameNameController;
  final void Function(CollectionType) onToggleCollection;
  final void Function(ImageSource) onPickImage;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          SectionHeader.title(title: AppText.createNewGameBoardGameImage),
          Observer(
            builder: (_) {
              return _ImageSection(
                onPickImage: (imageSource) => onPickImage(imageSource),
              );
            },
          ),
          SectionHeader.titles(
            primaryTitle: AppText.createNewGameBoardGameName,
            secondaryTitle: AppText.createNewGameBoardGameCollections,
          ),
          Observer(
            builder: (_) {
              return _NameAndCollectionsSection(
                boardGameNameController: boardGameNameController,
                boardGame: viewModel.boardGame,
                onToggleCollection: onToggleCollection,
              );
            },
          ),
          SectionHeader.title(title: AppText.createNewGameBoardGameRating),
          Observer(
            builder: (_) {
              return _RatingSection(
                rating: viewModel.rating,
                onRatingChanged: (rating) => viewModel.updateRating(rating),
              );
            },
          ),
          SectionHeader.title(title: AppText.createNewGameBoardGamePlayers),
          Observer(
            builder: (_) {
              return _PlayersSection(
                minPlayers: viewModel.minPlayers,
                maxPlayers: viewModel.maxPlayers,
                onNumberOfPlayersChanged: (minPlayers, maxPlayers) =>
                    viewModel.updateNumberOfPlayers(minPlayers, maxPlayers),
              );
            },
          ),
          SectionHeader.title(title: AppText.createNewGameBoardGamePlaytime),
          Observer(
            builder: (_) {
              return _PlaytimeSection(
                minPlaytime: viewModel.minPlaytime,
                maxPlaytime: viewModel.maxPlaytime,
                onPlaytimeChanged: (minPlaytime, maxPlaytime) =>
                    viewModel.updatePlaytime(minPlaytime, maxPlaytime),
              );
            },
          ),
          SectionHeader.title(title: AppText.createNewGameBoardGameMinAge),
          Observer(
            builder: (_) {
              return _AgeSection(
                minAge: viewModel.minAge,
                onMinAgeChanged: (minAge) => viewModel.updateMinAge(minAge),
              );
            },
          ),
          const SizedBox(height: Dimensions.floatingActionButtonBottomSpacing),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.onPickImage,
    Key? key,
  }) : super(key: key);

  static const double _iconSize = 32;

  final void Function(ImageSource) onPickImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.halfStandardSpacing,
        vertical: Dimensions.standardSpacing,
      ),
      child: Row(
        children: [
          CustomIconButton(
            const Icon(Icons.filter, color: AppColors.defaultTextColor, size: _iconSize),
            onTap: () => onPickImage(ImageSource.gallery),
          ),
          const SizedBox(width: Dimensions.standardSpacing),
          CustomIconButton(
            const Icon(Icons.camera, color: AppColors.defaultTextColor, size: _iconSize),
            onTap: () => onPickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}

class _RatingSection extends StatelessWidget {
  const _RatingSection({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  static const double _minValue = 0;
  static const double _maxValue = 100;

  final double? rating;
  final void Function(double?) onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            AppText.createNewGameBoardGameRatingNotSet,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
          Expanded(
            child: Slider(
              value: (rating ?? 0) * 10,
              min: _minValue,
              divisions: _maxValue.toInt(),
              max: _maxValue,
              label: '${rating ?? AppText.createNewGameBoardGameRatingNotSet}',
              onChanged: (value) {
                if (value == 0) {
                  onRatingChanged(null);
                } else {
                  onRatingChanged(value.floor() / 10);
                }
              },
              activeColor: AppColors.accentColor,
            ),
          ),
          const Text(
            AppText.createNewGameBoardGameRatingMax,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
        ],
      ),
    );
  }
}

class _PlayersSection extends StatelessWidget {
  const _PlayersSection({
    Key? key,
    required this.minPlayers,
    required this.maxPlayers,
    required this.onNumberOfPlayersChanged,
  }) : super(key: key);

  static const double _minValue = 1;
  static const double _maxValue = 20;

  final int minPlayers;
  final int maxPlayers;
  final void Function(int, int) onNumberOfPlayersChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            AppText.createNewGameBoardGamePlayersMin,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
          Expanded(
            child: RangeSlider(
              values: RangeValues(minPlayers.toDouble(), maxPlayers.toDouble()),
              min: _minValue,
              divisions: (_maxValue - _minValue).toInt(),
              max: _maxValue,
              labels: RangeLabels('$minPlayers', '$maxPlayers'),
              onChanged: (rangeValues) =>
                  onNumberOfPlayersChanged(rangeValues.start.toInt(), rangeValues.end.toInt()),
              activeColor: AppColors.accentColor,
            ),
          ),
          const Text(
            AppText.createNewGameBoardGamePlayersMax,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
        ],
      ),
    );
  }
}

class _PlaytimeSection extends StatelessWidget {
  const _PlaytimeSection({
    Key? key,
    required this.minPlaytime,
    required this.maxPlaytime,
    required this.onPlaytimeChanged,
  }) : super(key: key);

  static const double _minValueInMinutes = 5;
  static const double _maxValueInMinutes = 240;

  final int minPlaytime;
  final int maxPlaytime;
  final void Function(int, int) onPlaytimeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            AppText.createNewGameBoardGamePlaytimeMin,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
          Expanded(
            child: RangeSlider(
              values: RangeValues(minPlaytime.toDouble(), maxPlaytime.toDouble()),
              min: _minValueInMinutes,
              divisions: (_maxValueInMinutes - _minValueInMinutes).toInt(),
              max: _maxValueInMinutes,
              labels: RangeLabels('$minPlaytime', '$maxPlaytime'),
              onChanged: (rangeValues) =>
                  onPlaytimeChanged(rangeValues.start.toInt(), rangeValues.end.toInt()),
              activeColor: AppColors.accentColor,
            ),
          ),
          const Text(
            AppText.createNewGameBoardGamePlaytimeMax,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
        ],
      ),
    );
  }
}

class _AgeSection extends StatelessWidget {
  const _AgeSection({
    Key? key,
    required this.minAge,
    required this.onMinAgeChanged,
  }) : super(key: key);

  static const double _minValue = 0;
  static const double _maxValue = 50;

  final int? minAge;
  final void Function(int?) onMinAgeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            AppText.createNewGameBoardGameAgeNotSet,
            style: TextStyle(fontSize: Dimensions.smallFontSize),
          ),
          Expanded(
            child: Slider(
              value: minAge?.toDouble() ?? 0,
              min: _minValue,
              divisions: (_maxValue - _minValue).toInt(),
              max: _maxValue,
              label: '${minAge ?? AppText.createNewGameBoardGameAgeNotSet}',
              onChanged: (value) {
                if (value == 0) {
                  onMinAgeChanged(null);
                } else {
                  onMinAgeChanged(value.floor());
                }
              },
              activeColor: AppColors.accentColor,
            ),
          ),
          Text(
            sprintf(AppText.createNewGameBoardGameAgeMaxFormat, [_maxValue.toStringAsFixed(0)]),
            style: const TextStyle(fontSize: Dimensions.smallFontSize),
          ),
        ],
      ),
    );
  }
}

class _NameAndCollectionsSection extends StatelessWidget {
  const _NameAndCollectionsSection({
    Key? key,
    required this.boardGameNameController,
    required this.boardGame,
    required this.onToggleCollection,
  }) : super(key: key);

  final TextEditingController boardGameNameController;
  final BoardGameDetails boardGame;
  final void Function(CollectionType p1) onToggleCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: boardGameNameController,
              style: AppTheme.defaultTextFieldStyle,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppText.createNewGameBoardGameNameValidationError;
                }

                return null;
              },
            ),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          CollectionFlags(
            isEditable: true,
            isOwned: boardGame.isOwned ?? false,
            isOnWishlist: boardGame.isOnWishlist ?? false,
            isOnFriendsList: boardGame.isFriends ?? false,
            onToggleCollection: (collectionType) => onToggleCollection(collectionType),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.boardGameName,
    required this.boardGameImageUri,
    required this.onPop,
  }) : super(key: key);

  final String boardGameName;
  final String? boardGameImageUri;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      automaticallyImplyLeading: false,
      elevation: Dimensions.defaultElevation,
      pinned: true,
      expandedHeight: Constants.boardGameDetailsImageHeight,
      actions: [
        IconButton(
          onPressed: () => onPop(),
          icon: const Icon(Icons.close),
        ),
      ],
      flexibleSpace: BgcFlexibleSpaceBar(
        boardGameName: boardGameName,
        boardGameImageUrl: boardGameImageUri,
      ),
    );
  }
}
