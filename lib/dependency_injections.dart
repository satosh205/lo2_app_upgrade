import 'package:injector/injector.dart';

import 'data/api/api_service.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/home_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/home_repository.dart';

void setupDependencyInjections() async {
  Injector injector = Injector.appInstance;
  injector.registerSingleton<ApiService>(() => ApiService());
  _authProviderDI(injector);
  _authRepositoryDI(injector);
  _homeProviderDI(injector);
  _homeRepositoryDI(injector);
  // _dealerProviderDI(injector);
  // _dealerRepositoryDI(injector);
}

void _authProviderDI(Injector injector) {
  injector.registerDependency<AuthProvider>(() {
    var api = injector.get<ApiService>();
    return AuthProvider(api: api);
  });
}

void _authRepositoryDI(Injector injector) {
  injector.registerDependency<AuthRepository>(() {
    var userProvider = injector.get<AuthProvider>();
    return AuthRepository(userProvider: userProvider);
  });
}

void _homeProviderDI(Injector injector) {
  injector.registerDependency<HomeProvider>(() {
    var api = injector.get<ApiService>();
    return HomeProvider(api: api);
  });
}

void _homeRepositoryDI(Injector injector) {
  injector.registerDependency<HomeRepository>(() {
    var homeProvider = injector.get<HomeProvider>();
    return HomeRepository(homeProvider: homeProvider);
  });
}

// void _dealerProviderDI(Injector injector) {
//   injector.registerDependency<DealerProvider>(() {
//     var api = injector.get<ApiService>();
//     return DealerProvider(api: api);
//   });
// }

// void _dealerRepositoryDI(Injector injector) {
//   injector.registerDependency<DealerRepository>(() {
//     var dealerProvider = injector.get<DealerProvider>();
//     return DealerRepository(dealerProvider: dealerProvider);
//   });
// }
