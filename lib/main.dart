import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_control/controller/bindings.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/app_pages.dart';
import 'package:volume_control/model/util/app_routes.dart';
import 'package:volume_control/view/scenario_list.dart';
import 'package:workmanager/workmanager.dart';
import 'model/util/dimens.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ScenarioModelAdapter());
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
              seedColor: Colors.deepPurple, brightness: Brightness.light),
          useMaterial3: true),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            kDebugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(Dimens.appBarHeight),
              child: Container(
                padding: const EdgeInsets.all(Dimens.paddingMedium),
                alignment: Alignment.topLeft,
                child: Text(AppConstants.noScenarioText,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimens.fontLarge,
                        color: scheme.onPrimary)),
              )),
          backgroundColor: scheme.primary),
      body: const ScenarioList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addScenario),
        tooltip: AppConstants.createScenario,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    try {
      print("workmanager:: backgroundTask: $task");
    } catch (e) {
      print('workmanger:: backgroundTask error: $e');
      return Future.error(e);
    }
    return Future.value(true);
  });
}
