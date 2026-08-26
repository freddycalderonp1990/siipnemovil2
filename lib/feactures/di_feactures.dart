import 'package:siipnemovil_v2/feactures/pushNotification/di.dart';

import 'app_moviles/di.dart';
import 'user/di.dart';

class DependencyInjectionFeactures {
  static init() {
    DependencyInjectionUser.init();
    DependencyInjectionAppsMoviles.init();

    DependencyInjectionPushNotification.init();
  }
}
