import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/services/theme_services.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import '../../model/util/dimens.dart';
import '../../model/util/string_resources.dart';
import '../../view_model/routes/app_routes.dart';
import 'scenario_list.dart';

class HomePage extends GetView<DBcontroller> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primaryContainer,
        centerTitle: false,
        title: Text(StringRes.noScenarioText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.fontExtraLarge,
              color: ThemeServices.of(context).textColor,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            children: [
              const SizedBox(width: Dimens.sizeDefault),
              Text(
                StringRes.createScenario,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: scheme.textColor),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.addScenario),
                icon: const Icon(Icons.add_rounded),
                iconSize: Dimens.sizeMediumLarge + 4,
                color: ThemeServices.of(context).textColor,
              ),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(Icons.settings),
                color: ThemeServices.of(context).textColor,
              ),
            ],
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                0,
                0.3,
                0.7,
              ],
                  colors: [
                scheme.primaryContainer,
                scheme.primaryContainer,
                scheme.surface,
              ])),
          padding: const EdgeInsets.symmetric(horizontal: Dimens.sizeSmall),
          child: const SafeArea(top: false, child: ScenarioList())),
    );
  }
}
