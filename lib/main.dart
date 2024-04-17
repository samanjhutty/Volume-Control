import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volume_control/controller/bindings.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/app_pages.dart';
import 'package:volume_control/model/util/app_routes.dart';
import 'package:volume_control/view/scenario_list.dart';
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
