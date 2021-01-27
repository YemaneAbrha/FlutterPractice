import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
// import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DioConnectivityRequestRetrier {
  Dio dio;
  Connectivity connectivity;
  DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });
//   Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
//     // Do The reconnectivity issue
//     StreamSubscription streamSubscription;
//     final responseCompleter = Completer<Response>();
//     streamSubscription = connectivity.onConnectivityChanged.listen((connectivityResult) async {
//       if (connectivityResult != ConnectivityResult.none) {
//         streamSubscription.cancel();
//         print(requestOptions);
//         responseCompleter.complete(dio.request(
//           requestOptions.path,
//           cancelToken: requestOptions.cancelToken,
//           data: requestOptions.data,
//           onReceiveProgress: requestOptions.onReceiveProgress,
//           onSendProgress: requestOptions.onSendProgress,
//           queryParameters: requestOptions.queryParameters,
//           options: requestOptions,
//         ));
//       }
//     });
//     return responseCompleter.future;
//   }
// }
  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          // Complete the completer instead of returning
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}
