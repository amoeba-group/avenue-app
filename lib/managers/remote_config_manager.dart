import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../config/env_config.dart';

class RemoteConfigManager {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static final RemoteConfigManager _instance = RemoteConfigManager._internal();
  factory RemoteConfigManager() => _instance;
  RemoteConfigManager._internal();

  Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 5),
        ),
      );

      await _remoteConfig.setDefaults({
        'url_bill': EnvConfig.current['urlAmoebaBill'],
      });

      await fetchAndActivate();
    } catch (e) {
      print('⚠️ Error init remote config: $e');
    }
  }

  String get urlBill => _remoteConfig.getString('url_bill');

  FutureOr fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }
}
