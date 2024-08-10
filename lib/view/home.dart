import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import '../model/util/dimens.dart';
import '../model/util/string_resources.dart';
import '../view_model/routes/app_routes.dart';
import 'scenario_list.dart';

class HomePage extends GetView<DBcontroller> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primaryContainer,
        title: const Text(StringRes.noScenarioText,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Dimens.fontExtraLarge,
                color: ColorRes.textColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            children: [
              const SizedBox(width: Dimens.sizeDefault),
              const Text(
                StringRes.createScenario,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.addScenario),
                icon: const Icon(Icons.add_rounded),
                iconSize: Dimens.sizeMediumLarge + 4,
                color: ColorRes.textColor,
              ),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(Icons.settings),
                color: ColorRes.textColor,
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
                1,
              ],
                  colors: [
                scheme.primaryContainer,
                scheme.primaryContainer.withOpacity(0.8),
                scheme.surface,
                scheme.surface,
              ])),
          padding: const EdgeInsets.symmetric(horizontal: Dimens.sizeSmall),
          child: const ScenarioList()),
    );
  }
}
