import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;

class PlayerScore extends StatelessWidget {
  final player_score_model.PlayerScore _playerScore;

  const PlayerScore(
    this._playerScore, {
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
                        imageUri: store.player.imageUri,
                        medal: store.medal,
                      ),
                      shadowOffset: Styles.defaultShadowOffset,
                      shadowColor: Theme.of(context).accentColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
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
                              Divider(
                                indent: Dimensions.halfStandardSpacing,
                              ),
                              Text(
                                store.player.name,
                                style: TextStyle(
                                  fontSize: Dimensions.largeFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Score',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                store.score?.value ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 56),
                              ),
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
}
