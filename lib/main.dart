import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/assets/dimens.dart';
import 'package:volume_control/controller/bindings.dart';
import 'package:volume_control/view/add_scenario.dart';
import 'package:volume_control/view/scenario_list.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBindings(),
      title: 'Volume Control',
      routes: {
        '/': (p0) => const MainPage(),
        '/scenario': (p0) => const AddScenario()
      },
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
              preferredSize: const Size.fromHeight(40),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text('No Scenario running',
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
        onPressed: () => Navigator.pushNamed(context, '/scenario'),
        tooltip: 'Create a Scenario',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
