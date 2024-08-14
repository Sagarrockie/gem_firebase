import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<void> initializeRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      await _remoteConfig.setDefaults({
        'displayDiscountedPrice': false,
      });

      bool updated = await _remoteConfig.fetchAndActivate();
      if (kDebugMode) {
        print('Remote Config updated: $updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing remote config: $e');
      }
    }
  }

  static bool get displayDiscountedPrice {
    return _remoteConfig.getBool('displayDiscountedPrice');
  }
}
