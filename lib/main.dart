import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_control/model/bindings.dart';
import 'package:volume_control/model/notification_services.dart';
import 'package:volume_control/view_model/dbcontroller.dart';
import 'package:volume_control/model/models/current_system_settings.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/app_pages.dart';
import 'package:volume_control/model/util/app_routes.dart';
import 'package:volume_control/view/scenario_list.dart';
import 'model/util/dimens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await NotificationServices.init();
  await Hive.initFlutter();
  Hive.registerAdapter(ScenarioModelAdapter());
  Hive.registerAdapter(CurrentSystemSettingsAdapter());
  await Hive.openBox(AppConstants.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBindings(),
      title: AppConstants.appName,
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
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              primaryContainer: const Color(0xFFCFBAF4),
              onPrimaryContainer: const Color(0xFF2C194E),
              secondaryContainer: const Color(0xFFF6F2FC),
              onSecondaryContainer: const Color(0xFF1C1C1C),
              seedColor: Colors.deepPurple,
              brightness: Brightness.light),
          useMaterial3: true),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              primaryContainer: const Color(0xFF2C194E),
              onPrimaryContainer: const Color(0xFFCFBAF4),
              secondaryContainer: const Color(0xFF1C1C1C),
              onSecondaryContainer: const Color(0xFFF6F2FC),
              seedColor: const Color(0xFF371F61),
              brightness: Brightness.dark),
          useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          title: Obx(() {
            Get.find<DBcontroller>().scenarioList.length;
            return Text(AppConstants.noScenarioText,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimens.fontExtraLarge,
                    color: scheme.onPrimaryContainer));
          }),
          actions: [
            Obx(
              () => IconButton(
                color: scheme.onPrimaryContainer,
                onPressed: () {
                  if (Get.find<DBcontroller>().darkTheme.value) {
                    Get.changeThemeMode(ThemeMode.light);
                  } else {
                    Get.changeThemeMode(ThemeMode.dark);
                  }
                  Get.find<DBcontroller>().darkTheme.value =
                      !Get.find<DBcontroller>().darkTheme.value;
                },
                isSelected: Get.find<DBcontroller>().darkTheme.value,
                icon: const Icon(Icons.dark_mode),
                selectedIcon: const Icon(Icons.light_mode),
              ),
            ),
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.settings),
              icon: const Icon(Icons.settings),
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(width: Dimens.marginDefault),
          ],
          backgroundColor: scheme.primaryContainer),
      body: const ScenarioList(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: scheme.onPrimaryContainer,
        foregroundColor: scheme.primaryContainer,
        onPressed: () => Get.toNamed(AppRoutes.addScenario),
        tooltip: AppConstants.createScenario,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
