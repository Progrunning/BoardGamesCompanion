import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerFutureBuilder<TFuture, TStore extends ChangeNotifier> extends StatelessWidget {

  ConsumerFutureBuilder({
    @required this.future,
    @required this.success,
    this.loading,
    Key key,
  }) : super(key: key);

  final Future<TFuture> future;
  final Widget Function(BuildContext context, TStore store) success;
  final Widget Function(BuildContext context) loading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        print("${snapshot.connectionState} ${snapshot.hasData}");
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const GenericErrorMessage();
          }

          return Consumer<TStore>(
            builder: (_, store, __) {
              return success(context, store);
            },
          );
        } else if (snapshot.hasError) {
          return const GenericErrorMessage();
        }

        if (loading != null) {
          return loading(context);
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
