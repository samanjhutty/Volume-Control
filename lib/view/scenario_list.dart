import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
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
              0.4,
              1,
            ],
                colors: [
              scheme.primary,
              scheme.primary,
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
                    return Card(
                        margin: const EdgeInsets.all(Dimens.marginDefault),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.marginMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w500),
                                child: list.repeat.isEmpty
                                    ? const Text(
                                        AppConstants.dayNever,
                                      )
                                    : list.repeat.length == Dimens.noOfDays
                                        ? const Text(AppConstants.everyday)
                                        : Text((list.repeat
                                                .toString()
                                                .replaceAll('[', ''))
                                            .replaceAll(']', '')),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${list.startTime} - ${list.endTime}',
                                  style: const TextStyle(
                                      fontSize: Dimens.fontMed,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                        AppConstants.toIcons(
                                            list.volumeMode.toLowerCase()),
                                        color: scheme.primary),
                                    const SizedBox(width: Dimens.marginDefault),
                                    _Switch(index: index)
                                  ],
                                ),
                              ),
                              list.title.isNotEmpty
                                  ? Text(
                                      list.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  : const SizedBox()
                            ],
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
    return Switch.adaptive(
      onChanged: (value) {
        setState(() {
          controller.scenarioList[widget.index].isON = value;
        });

        /// writes the changes to local storage
        controller.box.put(AppConstants.scenarioList, controller.scenarioList);
      },
      value: controller.scenarioList[widget.index].isON,
    );
  }
}
