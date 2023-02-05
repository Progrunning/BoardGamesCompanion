import 'package:board_games_companion/widgets/common/board_game/collection_flags.dart';
import 'package:board_games_companion/widgets/common/page_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../widgets/board_games/board_game_image.dart';
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
    boardGameNameController.text = widget.viewModel.boardGameName;
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
          // TODO What type of navigation this should be? Perhaps a popup, rather than a regular stacked page?
          body: SafeArea(
            child: PageContainer(
              child: CustomScrollView(
                slivers: [
                  Observer(
                    builder: (_) {
                      return _Header(
                        boardGameName: widget.viewModel.boardGameName,
                        boardGameImageUri: widget.viewModel.boardGameImageUri,
                      );
                    },
                  ),
                  _Form(boardGameNameController: boardGameNameController),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () => widget.viewModel.saveBoardGame(),
          ),
        ),
      );

  Future<bool> _handleOnWillPop() async {
    return true;
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
    required this.boardGameNameController,
  }) : super(key: key);

  final TextEditingController boardGameNameController;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: boardGameNameController,
                      decoration: const InputDecoration(
                        labelText: AppText.createNewGameBoardGameName,
                        labelStyle: AppTheme.defaultTextFieldLabelStyle,
                      ),
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
                    isOwned: false,
                    isOnWishlist: false,
                    isOnFriendsList: false,
                    onToggleCollection: (collectionType) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.boardGameName,
    required this.boardGameImageUri,
  }) : super(key: key);

  final String boardGameName;
  final String? boardGameImageUri;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      elevation: Dimensions.defaultElevation,
      pinned: true,
      expandedHeight: Constants.boardGameDetailsImageHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppStyles.defaultCornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Text(
              boardGameName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.defaultTextColor,
                fontSize: Dimensions.largeFontSize,
              ),
            ),
          ),
        ),
        background: BoardGameImage(
          url: boardGameImageUri,
          minImageHeight: Constants.boardGameDetailsImageHeight,
        ),
      ),
    );
  }
}
