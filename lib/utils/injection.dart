import 'package:get_it/get_it.dart';
import 'package:room952_monitoring/networking/MqttManager.dart';

final GetIt locator = GetIt.instance;

void getInjection() async {
  if (!locator.isRegistered<MqttManager>()) {
    // locator.registerLazySingleton<MqttManager>(
    //   () => MqttManagerImpl(),
    // );
    locator.registerSingleton<MqttManager>(MqttManagerImpl());
  }
}
