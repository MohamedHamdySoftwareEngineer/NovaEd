import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setDefaults({'api_base_url': 'https://default.com'});
    await remoteConfig.fetchAndActivate();
  }

  String get apiBaseUrl => remoteConfig.getString('api_base_url');
}
