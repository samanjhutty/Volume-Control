import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/services/extension_methods.dart';
import 'package:volume_control/services/theme_services.dart';
import 'package:volume_control/view/widgets/switch_widget.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/string_resources.dart';
import 'package:volume_control/view_model/routes/app_routes.dart';
import '../model/util/dimens.dart';

class ScenarioList extends GetView<DBcontroller> {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ThemeServices.of(context);
    AuthServices services = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Visibility(
            visible: controller.scenarioList.isEmpty,
            child: Container(
              height: MediaQuery.sizeOf(context).height * .3,
              alignment: Alignment.bottomCenter,
              child: Text(
                'Click on + icon to add scenarios',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ThemeServices.of(context).surface.withOpacity(0.5),
                    fontWeight: FontWeight.w900,
                    fontSize: Dimens.fontSuperSuperLarge),
              ),
            ))),
        Expanded(
          child: Obx(() {
            return ListView.builder(
                itemCount: controller.scenarioList.length,
                itemBuilder: (context, index) {
                  ScenarioModel data = controller.scenarioList[index];
                  Color textColor = scheme.onPrimaryContainer;

                  return Card(
                    color: scheme.background,
                    surfaceTintColor: Colors.transparent,
                    elevation: Dimens.sizeSmall,
                    margin: const EdgeInsets.all(Dimens.sizeSmall),
                    child: InkWell(
                      onTap: () =>
                          Get.toNamed(AppRoutes.addScenario, arguments: index),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimens.borderRadiusDefault)),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.sizeDefault),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.repeatDaysText(data.repeat ?? []),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: Dimens.sizeSmall),
                                DefaultTextStyle(
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: Dimens.fontExtraLarge,
                                      fontWeight: FontWeight.bold),
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        Text(
                                          services.is24hrFormat.value
                                              ? data.startTime.toTimeOfDay
                                                  .formatTime24H
                                              : data.startTime.toTimeOfDay
                                                  .format(context),
                                        ),
                                        const Text(' - '),
                                        Text(
                                          services.is24hrFormat.value
                                              ? data.endTime.toTimeOfDay
                                                  .formatTime24H
                                              : data.endTime.toTimeOfDay
                                                  .format(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (data.title != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimens.sizeSmall),
                                    child: Text(
                                      data.title ?? '',
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                    StringRes.toIcons(
                                        data.volumeMode.toLowerCase()),
                                    height: Dimens.sizeMedium,
                                    fit: BoxFit.cover,
                                    color: textColor),
                                const SizedBox(width: Dimens.sizeSmall),
                                MySwitchWidget(
                                  value: data.isON,
                                  onChanged: (value) {
                                    controller.scenarioList[index].isON = value;
                                    controller
                                        .saveList(controller.scenarioList);
                                    if (value) {
                                      createScenario(
                                          tag: index + 1,
                                          startTime: data.startTime.toDateTime,
                                          endTime: data.endTime.toDateTime);
                                      return;
                                    }
                                    AndroidAlarmManager.cancel(index + 1);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
        ),
      ],
    );
  }
}
