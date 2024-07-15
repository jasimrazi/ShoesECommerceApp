import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  void Function(bool)? onConnectionChange;

  ConnectivityService({this.onConnectionChange}) {
    _subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final hasConnection = result != ConnectivityResult.none;
      if (onConnectionChange != null) {
        onConnectionChange!(hasConnection);
      }
    });
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();

    return result != ConnectivityResult.none;
  }

  void dispose() {
    _subscription.cancel();
  }
}
