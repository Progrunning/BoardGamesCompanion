import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/common/board_game/collection_flags.dart';
import 'package:board_games_companion/widgets/common/page_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../widgets/board_games/bgc_flexible_space_bar.dart';
import '../../widgets/common/section_header.dart';
import 'create_board_game_view_model.dart';

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

  @override
  void initState() {
    super.initState();
    boardGameNameController.text = widget.viewModel.boardGame.name;
    boardGameNameController.addListener(() {
      widget.viewModel.setBoardGameName(boardGameNameController.text);
    });
  }

  @override
  void dispose() {
    boardGameNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => _handleOnWillPop(),
        child: Scaffold(
          body: SafeArea(
            child: PageContainer(
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
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Observer(
            builder: (_) {
              return FloatingActionButton(
                child: widget.viewModel.visualState.when(
                  editGame: () => const Icon(Icons.save),
                  saveSuccess: () => const Icon(Icons.save),
                  saveFailure: () => const Icon(Icons.save),
                  saving: () => const CircularProgressIndicator(color: AppColors.primaryColor),
                ),
                onPressed: () => _saveBoardGame(),
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

  Future<void> _saveBoardGame() async {
    final navigatorState = Navigator.of(context);
    await widget.viewModel.saveBoardGame();
    navigatorState.pop();
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
    required this.viewModel,
    required this.boardGameNameController,
    required this.onToggleCollection,
  }) : super(key: key);

  final CreateBoardGameViewModel viewModel;
  final TextEditingController boardGameNameController;
  final void Function(CollectionType) onToggleCollection;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Form(
        child: Column(
          children: [
            const SectionHeader(
              primaryTitle: AppText.createNewGameBoardGameName,
              secondaryTitle: AppText.createNewGameBoardGameCollections,
            ),
            const SizedBox(height: Dimensions.halfStandardSpacing),
            Observer(
              builder: (_) {
                return _NameAndCollectionsSection(
                  boardGameNameController: boardGameNameController,
                  boardGame: viewModel.boardGame,
                  onToggleCollection: onToggleCollection,
                );
              },
            ),
            const SectionHeader(primaryTitle: AppText.createNewGameBoardGameRating),
            Observer(
              builder: (_) {
                return _RatingSection(
                  rating: viewModel.rating,
                  onRatingChanged: (rating) => viewModel.updateRating(rating),
                );
              },
            ),
          ],
        ),
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
