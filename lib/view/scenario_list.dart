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
    var scheme = ThemeServices.of(context);

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
                    color: scheme.onPrimary.withOpacity(.2),
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
                    surfaceTintColor: scheme.primary,
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
                                FormatTime(
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: Dimens.fontExtraLarge,
                                        fontWeight: FontWeight.bold),
                                    startTime: data.startTime.toTimeOfDay,
                                    endTime: data.endTime.toTimeOfDay),
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
                                          tag: index,
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

class FormatTime extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TextStyle? style;
  const FormatTime(
      {super.key, required this.startTime, required this.endTime, this.style});

  @override
  Widget build(BuildContext context) {
    AuthServices services = Get.find();

    return Obx(() {
      bool value = services.is24hrFormat.value;

      if (value) {
        return Row(
          children: [
            Text(startTime.format24H, style: style),
            const SizedBox(width: Dimens.sizeExtraSmall),
            Text(' - ', style: style),
            const SizedBox(width: Dimens.sizeExtraSmall),
            Text(endTime.format24H, style: style),
          ],
        );
      }

      String start = _removePeriod(startTime.format(context));
      String end = _removePeriod(endTime.format(context));

      return Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(text: start, style: style),
            const WidgetSpan(child: SizedBox(width: Dimens.sizeExtraSmall)),
            TextSpan(
                text: startTime.period.name.toUpperCase(),
                style: style?.copyWith(fontSize: (style?.fontSize ?? 0) * 0.8)),
          ])),
          const SizedBox(width: Dimens.sizeExtraSmall),
          Text(' - ', style: style),
          const SizedBox(width: Dimens.sizeExtraSmall),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: end, style: style),
            const WidgetSpan(child: SizedBox(width: Dimens.sizeExtraSmall)),
            TextSpan(
                text: endTime.period.name.toUpperCase(),
                style: style?.copyWith(fontSize: (style?.fontSize ?? 0) * 0.8)),
          ])),
        ],
      );
    });
  }

  String _removePeriod(String time) {
    return time.replaceAll(RegExp(r'\b(?:AM|PM)\b'), '')..removeAllWhitespace;
  }
}
