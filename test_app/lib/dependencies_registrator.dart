import 'package:get_it/get_it.dart';
import 'clients/http_client.dart';
import 'storages/session_storage.dart';

class DependenciesRegistrator {
  static final GetIt container = GetIt.instance;

  void initializeDependencies() {
    container.registerSingleton<SessionStorage>(SessionStorage());
    container.registerSingleton<HttpClient>(HttpClient());
  }
}
