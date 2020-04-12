import 'package:async/async.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/widgets/board_games/board_game_search_item_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/hot_board_games_header.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_board_games_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SearchBoardGamesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBoardGamesPageState();
}

class _SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  AsyncMemoizer _memoizer;
  bool _isRefreshing;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    final _boardGamesGeekService = Provider.of<BoardGamesGeekService>(
      context,
      listen: false,
    );

    return Scaffold(
        body: PageContainer(
      child: FutureBuilder(
        future: _memoizer.runOnce(
          () async {
            return _boardGamesGeekService.retrieveHot();
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _isRefreshing = false;

            if (snapshot.data is List<BoardGame>) {
              return SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: AppTheme.defaultTextColor,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ),
                    ),
                    SaerchBoardGamesResults(),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: HotBoardGamesHeader(),
                    ),
                    SliverGrid.extent(
                      maxCrossAxisExtent: 150,
                      children: List.generate(
                        (snapshot.data as List<BoardGame>).length,
                        (int index) {
                          return BoardGameSearchItemWidget(
                            boardGame: snapshot.data[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Center(
                      child: Text(
                          'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.'),
                    ),
                  ),
                  SizedBox(height: Dimensions.standardSpacing),
                  RaisedButton(
                    child: Text('Refresh'),
                    onPressed: () {
                      setState(() {
                        _isRefreshing = true;
                      });
                    },
                  )
                ],
              ),
            );
          } else if (snapshot.hasError && !_isRefreshing) {
            return Center(child: Text('Oops, something went wrong'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}
