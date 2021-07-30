import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/animation_tags.dart';
import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';
import '../../../common/styles.dart';
import '../../../stores/playthrough_store.dart';
import '../../../stores/playthroughs_store.dart';
import '../../common/default_icon.dart';
import '../../common/icon_and_text_button.dart';
import '../../common/rank_ribbon.dart';
import '../../common/shadow_box_widget.dart';
import '../player_avatar.dart';
import '../player_avatar_subtitle_widget.dart';
import 'player_score_edit_widget.dart';

class PlayerScore extends StatelessWidget {

  const PlayerScore(
    this._playerScore, {
    this.readonly = true,
    this.editMode = false,
    this.playthroughStore,
    Key key,
  }) : super(key: key);

  final player_score_model.PlayerScore _playerScore;
  final PlaythroughStore playthroughStore;
  final bool readonly;
  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final playerScoreController = TextEditingController();
    playerScoreController.text = _playerScore?.score?.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ChangeNotifierProvider.value(
          value: _playerScore,
          child: Consumer<player_score_model.PlayerScore>(
            builder: (_, store, __) {
              Widget playerAvatar = ShadowBox(
                child: PlayerAvatar(
                  imageUri: store?.player?.avatarImageUri,
                  medal: store?.medal,
                ),
              );
              if ((store?.player?.id?.isNotEmpty ?? false) &&
                  (store.score?.id?.isNotEmpty ?? false)) {
                playerAvatar = Hero(
                    tag:
                        '${AnimationTags.playerImageHeroTag}${store?.player?.id}${store?.score?.id}',
                    child: playerAvatar);
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: Dimensions.defaultPlayerAvatarHeight,
                    width: Dimensions.defaultPlayerAvatarHeight,
                    child: Stack(
                      children: <Widget>[
                        playerAvatar,
                        if (store?.player?.name?.isNotEmpty ?? false)
                          PlayerAvatarSubtitle(
                            player: store?.player,
                          ),
                        if ((store?.score?.value?.isNotEmpty ?? false) &&
                            store.place != null)
                          Positioned(
                            top: -Styles.defaultShadowRadius - 1,
                            right: 0,
                            child: RankRibbon(store?.place),
                          ),
                      ],
                    ),
                  ),
                  if (editMode)
                    PlayerScoreEdit(
                      controller: playerScoreController,
                      onSubmit: (String value) async {
                        await _updatePlayerScore(
                          value,
                          context,
                        );
                      },
                    ),
                  if (!editMode)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: Dimensions.standardSpacing,
                      ),
                      child: Text(
                        'Score',
                        style: AppTheme.sectionHeaderTextStyle,
                      ),
                    ),
                  if (!editMode)
                    IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              store?.score?.value ?? '-',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.standardSpacing,
                          ),
                          if (!readonly)
                            Align(
                              alignment: Alignment.center,
                              child: IconAndTextButton(
                                icon: const DefaultIcon(Icons.edit),
                                horizontalPadding: Dimensions.standardSpacing,
                                onPressed: () => _showCreateOrEditScoreDialog(
                                    context, store),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (editMode)
          const SizedBox(
            height: Dimensions.standardSpacing,
          ),
        if (editMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconAndTextButton(
                icon: const DefaultIcon(Icons.cancel),                
                title: 'Cancel',
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(
                width: Dimensions.standardSpacing,
              ),
              IconAndTextButton(
                icon: const DefaultIcon(Icons.save),                
                title: 'Save',
                onPressed: () => _updatePlayerScore(
                  playerScoreController.value.text,
                  context,
                ),
              ),
            ],
          )
      ],
    );
  }

  Future<void> _showCreateOrEditScoreDialog(
      BuildContext context, player_score_model.PlayerScore playerScore) async {
    if (playthroughStore == null) {
      return;
    }

    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryColor,
          content: ChangeNotifierProvider.value(
            value: playthroughStore,
            child: PlayerScore(
              playerScore,
              editMode: true,
              playthroughStore: playthroughStore,
            ),
          ),
        );
      },
    );
  }

  Future<void> _updatePlayerScore(
    String value,
    BuildContext context,
  ) async {
    if (playthroughStore == null ||
        !await _playerScore.updatePlayerScore(value)) {
      return;
    }

    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );

    await playthroughsStore.updatePlaythrough(playthroughStore.playthrough);
    Navigator.pop(context);
  }
}
