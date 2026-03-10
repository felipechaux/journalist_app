import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network_info.dart';

enum NetworkStatus { connected, disconnected, initial }

class NetworkCubit extends Cubit<NetworkStatus> {
  final NetworkInfo networkInfo;
  late StreamSubscription _subscription;

  NetworkCubit(this.networkInfo) : super(NetworkStatus.initial) {
    _checkInitialConnectivity();
    _monitorConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    emit(isConnected ? NetworkStatus.connected : NetworkStatus.disconnected);
  }

  void _monitorConnectivity() {
    _subscription = networkInfo.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkStatus.disconnected);
      } else {
        emit(NetworkStatus.connected);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
