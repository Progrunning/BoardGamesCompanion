import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_detail_floating_actions_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_header_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_games_details_body_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';

class BoardGamesDetailsPage extends StatelessWidget {
  final String _boardGameId;
  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  BoardGamesDetailsPage(
    this._boardGameDetailsStore,
    this._boardGameId,
    this._boardGameName,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageContainer(
          child: CustomScrollView(
            slivers: <Widget>[
              BoardGamesDetailsHeader(
                boardGameDetailsStore: _boardGameDetailsStore,
                boardGameName: _boardGameName,
              ),
              BoardGamesDetailsBody(
                boardGameId: _boardGameId,
                boardGameDetailsStore: _boardGameDetailsStore,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BoardGameDetailFloatingActions(),
    );
  }
}

// child: Scaffold(
//   appBar: AppBar(
//     title: Text(_boardGameName ?? ''),
//   ),
//   body: PageContainer(
//     child: ConsumerFutureBuilder<BoardGameDetails, BoardGameDetailsStore>(
//       future: _loadBoardGameDetailsMemoizer.runOnce(() =>
//           _boardGameDetailsStore.loadBoardGameDetails(_boardGameId)),
//       loading: (_) {
//         return Center(
//           child: LoadingIndicator(),
//         );
//       },
//       success: (_, store) {
//         if (store.boardGameDetails != null) {
//           return SingleChildScrollView(
//             child:
//             ),
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(Dimensions.standardSpacing),
//                 child: Center(
//                   child: Text(
//                       'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.'),
//                 ),
//               ),
//               SizedBox(height: Dimensions.standardSpacing),
//               RaisedButton(
//                 child: Text('Refresh'),
//                 onPressed: () =>
//                     _refreshBoardGameDetails(_boardGameId, store),
//               )
//             ],
//           ),
//         );
//       },
//     ),
//   ),
//   floatingActionButton: BoardGameDetailFloatingActions(),
// ),
