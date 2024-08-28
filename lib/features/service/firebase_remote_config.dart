import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigService {
  Future<void> fetchAndActivate();
  String getApiKey();
  String getEngineID();
  String getBaseURL();
}

class FirebaseRemoteConfigService implements RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigService(this._remoteConfig);

  @override
  Future<void> fetchAndActivate() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  @override
  String getApiKey() {
    return _remoteConfig.getString('APIKEY');
  }

  @override
  String getEngineID() {
    return _remoteConfig.getString('EngineID');
  }

  @override
  String getBaseURL() {
    return _remoteConfig.getString("BaseURL");
  }
}
