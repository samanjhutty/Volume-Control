import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/services/theme_services.dart';
import 'package:volume_control/view_model/bindings.dart';
import 'package:volume_control/services/notification_services.dart';
import 'package:volume_control/model/util/string_resources.dart';
import 'package:volume_control/view_model/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const ThemeServices(child: MyApp()));
}

Future initServices() async {
  logPrint('init services started...');
  try {
    await Hive.initFlutter();
    await Hive.openBox(StringRes.boxName);
    await Get.putAsync(() => AuthServices().init());
    await AndroidAlarmManager.initialize();
    await NotificationServices.init();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  } catch (e) {
    logPrint('init services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<AuthServices>().theme;

    return GetMaterialApp(
      initialBinding: InitBindings(),
      title: StringRes.appName,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.zoom,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, child!),
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(600, name: TABLET),
          const ResponsiveBreakpoint.resize(800, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(1700, name: '4K'),
        ],
      ),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              primary: theme.primary,
              onPrimary: theme.onPrimary,
              seedColor: theme.primary,
              brightness: theme.brightness),
          useMaterial3: true),
    );
  }
}
