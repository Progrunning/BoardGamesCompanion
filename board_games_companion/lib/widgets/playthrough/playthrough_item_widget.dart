import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/widgets/player/player_score_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughItem extends StatelessWidget {
  final Playthrough _playthrough;

  const PlaythroughItem(
    this._playthrough, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(
            Styles.defaultCornerRadius,
          )),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor,
              offset: Styles.defaultShadowOffset,
              blurRadius: Styles.defaultShadowRadius,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            Dimensions.standardSpacing,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing,
            ),
            child: ChangeNotifierProvider.value(
              value: _playthrough,
              child: Consumer<Playthrough>(
                builder: (_, store, __) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CalendarCard(store.startDate),
                          SizedBox(
                            height: Dimensions.standardSpacing,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  PlaythroughItemDetail('443', 'day(s) ago'),
                                  Divider(
                                    height: Dimensions.standardSpacing,
                                  ),
                                  PlaythroughItemDetail('10th', 'game'),
                                  Divider(
                                    height: Dimensions.standardSpacing,
                                  ),
                                  PlaythroughItemDetail('1987', 'highscore'),
                                  Divider(
                                    height: Dimensions.standardSpacing,
                                  ),
                                  PlaythroughItemDetail('120min', 'duration'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Dimensions.standardSpacing,
                      ),
                      Expanded(
                        child: ListView.separated(
                            itemCount: 4,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dimensions.standardSpacing,
                              );
                            },
                            itemBuilder: (context, index) {
                              return PlayerScore(
                                medal: MedalEnum.Bronze,
                              );
                            }),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
