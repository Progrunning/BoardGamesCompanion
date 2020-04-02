import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;

class PlayerScore extends StatelessWidget {
  final player_score_model.PlayerScore _playerScore;
  final bool readonly;
  final bool editMode;

  const PlayerScore(
    this._playerScore, {
    this.readonly = true,
    this.editMode = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: Dimensions.defaultPlayerAvatarHeight,
        child: ChangeNotifierProvider.value(
          value: _playerScore,
          child: Consumer<player_score_model.PlayerScore>(
            builder: (_, store, __) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ShadowBox(
                      child: PlayerAvatar(
                        imageUri: store?.player?.imageUri,
                        medal: store?.medal,
                      ),
                      shadowOffset: Styles.defaultShadowOffset,
                      shadowColor: Theme.of(context).accentColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.standardSpacing,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: Dimensions.halfStandardSpacing,
                              ),
                              Text(
                                store?.player?.name ?? '-',
                                style: TextStyle(
                                  fontSize: Dimensions.largeFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (editMode)
                            Material(
                              child: TextFormField(
                                initialValue: store.score?.value,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Score',
                                ),
                                onFieldSubmitted: (value) {
                                  store.updatePlayerScore(value);
                                },
                              ),
                            ),
                          if (!editMode)
                            Text(
                              'Score',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          if (!readonly)
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    store?.score?.value ?? '-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 56),
                                  ),
                                  IconAndTextButton(
                                    icon: Icons.edit,
                                    horizontalPadding:
                                        Dimensions.standardSpacing,
                                    verticalPadding: Dimensions.standardSpacing,
                                    onPressed: () =>
                                        _showCreateOrEditScoreDialog(
                                            context, store),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateOrEditScoreDialog(
      BuildContext context, player_score_model.PlayerScore playerScore) async {
    await showDialog(
      context: context,
      builder: (_) {
        return SafeArea(
          child: AlertDialog(
            title: Text('${playerScore.player.name}\'s score'),
            content: PlayerScore(
              playerScore,
              editMode: true,
            ),
          ),
        );
      },
    );
  }
}
