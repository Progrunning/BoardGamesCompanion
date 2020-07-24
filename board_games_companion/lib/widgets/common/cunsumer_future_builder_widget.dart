import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerFutureBuilder<TFuture, TStore extends ChangeNotifier>
    extends StatelessWidget {
  final Future<TFuture> _future;
  final Widget Function(BuildContext context, TStore store) _success;
  final Widget Function(BuildContext context) _loading;

  ConsumerFutureBuilder({
    @required future,
    @required success,
    loading,
    Key key,
  })  : this._future = future,
        this._success = success,
        this._loading = loading,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        print("${snapshot.connectionState} ${snapshot.hasData}");
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return GenericErrorMessage();
          }

          return Consumer<TStore>(
            builder: (_, store, __) {
              return _success(context, store);
            },
          );
        } else if (snapshot.hasError) {
          return GenericErrorMessage();
        }

        if (_loading != null) {
          return _loading(context);
        } else {
          return LoadingIndicator();
        }
      },
    );
  }
}
