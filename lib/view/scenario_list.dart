import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/entension_methods.dart';
import '../model/util/dimens.dart';

class ScenarioList extends GetView<DBcontroller> {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: Dimens.marginDefault),
        child: Obx(() {
          return controller.scenarioList.isEmpty
              ? Center(
                  child: Text(
                    'Click on + icon to add scenarios',
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.scenarioList.length,
                  itemBuilder: (context, index) {
                    ScenarioModel list = controller.scenarioList[index];
                    Color textColor = scheme.onPrimaryContainer;

                    return Card(
                        color: scheme.secondaryContainer,
                        elevation: Dimens.sizeExtraSmall,
                        margin: const EdgeInsets.all(Dimens.marginDefault),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimens.marginMedium,
                            Dimens.marginMedium,
                            Dimens.marginMedium,
                            Dimens.zero,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .repeatDaysText(list.repeat),
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                            height: Dimens.marginDefault),
                                        DefaultTextStyle(
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: Dimens.fontExtraLarge,
                                              fontWeight: FontWeight.bold),
                                          child: Obx(
                                            () => Row(
                                              children: [
                                                Text(
                                                  controller.is24hrFormat.value
                                                      ? list
                                                          .startTime
                                                          .toTimeOfDay
                                                          .formatTime24H
                                                      : list
                                                          .startTime.toTimeOfDay
                                                          .format(context),
                                                ),
                                                const Text(' - '),
                                                Text(
                                                  controller.is24hrFormat.value
                                                      ? list.endTime.toTimeOfDay
                                                          .formatTime24H
                                                      : list.endTime.toTimeOfDay
                                                          .format(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      list.title,
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: Dimens.marginSmall),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                            AppConstants.toIcons(
                                                list.volumeMode.toLowerCase()),
                                            height: Dimens.sizeDefault,
                                            color: textColor),
                                        const SizedBox(
                                            width: Dimens.marginDefault),
                                        _Switch(index: index)
                                      ],
                                    ),
                                    PopupMenuButton(
                                        iconColor: textColor,
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons
                                                        .edit_notifications),
                                                    SizedBox(
                                                        width: Dimens
                                                            .paddingDefault),
                                                    Text('Edit'),
                                                  ],
                                                ),
                                                onTap: () {},
                                              ),
                                              PopupMenuItem(
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(
                                                        width: Dimens
                                                            .paddingDefault),
                                                    Text('Delete'),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  controller.scenarioList
                                                      .removeAt(index);

                                                  /// writes the changes to local storage
                                                  controller.saveList(
                                                      controller.scenarioList);

                                                  // cancels the schedule
                                                  await AndroidAlarmManager
                                                      .cancel(list.tag);
                                                },
                                              ),
                                            ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  });
        }));
  }
}

class _Switch extends StatefulWidget {
  final int index;
  const _Switch({required this.index});

  @override
  State<_Switch> createState() => _SwitchState();
}

class _SwitchState extends State<_Switch> {
  DBcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Switch.adaptive(
      activeColor: scheme.primaryContainer,
      activeTrackColor: scheme.onPrimaryContainer,
      onChanged: (value) {
        setState(() {
          controller.scenarioList[widget.index].isON = value;
        });
        if (value) {
          print(
              'time of day: ${controller.scenarioList[widget.index].startTime}');
          controller.bgSchedular(
              controller.scenarioList[widget.index].tag,
              controller.dateTimeFromTimeOfDay(
                  controller.scenarioList[widget.index].startTime.toTimeOfDay));
        } else {
          AndroidAlarmManager.cancel(controller.scenarioList[widget.index].tag);
        }

        /// writes the changes to local storage
        controller.saveList(controller.scenarioList);
      },
      value: controller.scenarioList[widget.index].isON,
    );
  }
}
