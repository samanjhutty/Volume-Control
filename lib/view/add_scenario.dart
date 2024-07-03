import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/view_model/controllers/add_scenario_controller.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/entension_methods.dart';
import '../model/util/dimens.dart';

class AddScenario extends GetView<AddScenarioController> {
  const AddScenario({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
              onPressed: controller.updateList != null
                  ? () async {
                      Get.find<DBcontroller>()
                          .scenarioList
                          .removeAt(controller.updateList!);
                      Get.back();

                      /// writes the changes to local storage
                      Get.find<DBcontroller>()
                          .saveList(Get.find<DBcontroller>().scenarioList);

                      // cancels the schedule
                      await AndroidAlarmManager.cancel(controller.updateList!);
                    }
                  : () => Get.back(),
              icon: Icon(
                Icons.delete,
                color: scheme.error,
              ))
        ],
      ),
      body: ColoredBox(
        color: scheme.primaryContainer,
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.startTime,
                              style:
                                  TextStyle(color: scheme.onPrimaryContainer),
                            ),
                            InkWell(
                              onTap: () async {
                                TimeOfDay? time = await controller.myTimePicker(
                                    context: context);
                                if (time != null) {
                                  controller.startTime.value = time;
                                }
                              },
                              child: Text(
                                  Get.find<DBcontroller>().is24hrFormat.value
                                      ? controller.startTime.value.formatTime24H
                                      : controller.startTime.value
                                          .format(context),
                                  style: TextStyle(
                                      color: scheme.onPrimaryContainer,
                                      fontSize: Dimens.fontSuperLarge,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ),
                    Obx(
                      () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.endTime,
                              style:
                                  TextStyle(color: scheme.onPrimaryContainer),
                            ),
                            InkWell(
                              onTap: () async {
                                TimeOfDay? time = await controller.myTimePicker(
                                    context: context);

                                if (time != null) {
                                  if (time == controller.startTime.value) {
                                    Get.rawSnackbar(
                                        message:
                                            'End time cannot be same as start time!');
                                  } else {
                                    controller.endTime.value = time;
                                  }
                                }
                              },
                              child: Text(
                                  Get.find<DBcontroller>().is24hrFormat.value
                                      ? controller.endTime.value.formatTime24H
                                      : controller.endTime.value
                                          .format(context),
                                  style: TextStyle(
                                      color: scheme.onPrimaryContainer,
                                      fontSize: Dimens.fontSuperLarge,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ),
                  ],
                )),
            Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(Dimens.marginMedium),
                  decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimens.borderRadiusLarge))),
                  child: ListView(children: [
                    const SizedBox(height: Dimens.marginDefault),
                    const Text(
                      AppConstants.repeat,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.fontLarge),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(Dimens.marginDefault),
                            child: Text(Get.find<DBcontroller>()
                                .repeatDaysText(controller.repeatDays)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimens.paddingDefault,
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(
                                () => ToggleButtons(
                                    fillColor: scheme.onPrimaryContainer,
                                    selectedColor: scheme.primaryContainer,
                                    renderBorder: false,
                                    borderRadius: BorderRadius.circular(
                                        Dimens.borderRadiusDefault),
                                    onPressed: (index) {
                                      controller.daySelected[index] =
                                          !controller.daySelected[index];
                                      if (controller.daySelected[index]) {
                                        controller.dayList[index].selected =
                                            true;
                                      } else {
                                        controller.dayList[index].selected =
                                            false;
                                      }
                                      controller.repeatDays.value =
                                          controller.daysRepeat();
                                    },
                                    isSelected: controller.daySelected,
                                    children: controller.days),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.paddingMedium,
                      ),
                      child: TextFormField(
                        controller: controller.titleController.value,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: scheme.onSurface),
                            labelText: AppConstants.sceName,
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: scheme.onPrimaryContainer))),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: Dimens.paddingDefault),
                      child: Text(AppConstants.volMode,
                          style: TextStyle(
                              fontSize: Dimens.fontLarge,
                              fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimens.paddingMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => RadioMenuButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: Dimens.marginMedium)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens
                                                    .borderRadiusMediumExtra)))),
                                value: AppConstants.volNormal,
                                groupValue: controller.volumeMode.value,
                                onChanged: (value) {
                                  controller.volumeMode.value = value!;
                                },
                                child: const Text(AppConstants.volNormal)),
                          ),
                          Obx(
                            () => RadioMenuButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: Dimens.marginMedium)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens
                                                    .borderRadiusMediumExtra)))),
                                value: AppConstants.volViberate,
                                groupValue: controller.volumeMode.value,
                                onChanged: (value) {
                                  controller.volumeMode.value = value!;
                                },
                                child: const Text(AppConstants.volViberate)),
                          ),
                          Obx(
                            () => RadioMenuButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: Dimens.marginMedium)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens
                                                    .borderRadiusMediumExtra)))),
                                value: AppConstants.volSilent,
                                groupValue: controller.volumeMode.value,
                                onChanged: (value) {
                                  controller.volumeMode.value = value!;
                                },
                                child: const Text(AppConstants.volSilent)),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: Dimens.paddingDefault),
                      child: Text(AppConstants.vol,
                          style: TextStyle(
                              fontSize: Dimens.fontLarge,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: Dimens.marginMedium),
                    Obx(
                      () => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: controller.changeVolume.value,
                          title: const Text(AppConstants.changeVol),
                          onChanged: (value) {
                            controller.changeVolume.value = value ?? false;
                          }),
                    ),
                    const SizedBox(height: Dimens.marginMedium),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                              child: Slider(
                                  thumbColor: scheme.onPrimaryContainer,
                                  activeColor: scheme.onPrimaryContainer,
                                  value: controller.volume.value,
                                  onChanged: controller.changeVolume.value
                                      ? (value) {
                                          controller.volume.value = value;
                                        }
                                      : null)),
                          Padding(
                            padding:
                                const EdgeInsets.all(Dimens.paddingDefault),
                            child: Text(
                              '${(controller.volume.value * 100).ceil()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: scheme.surface,
        padding: const EdgeInsets.only(bottom: Dimens.marginDefault),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: scheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.marginMedium,
                        horizontal: Dimens.marginLarge,
                      )),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppConstants.cancel)),
            ),
            const SizedBox(height: Dimens.marginDefault),
            Expanded(
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: scheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.marginMedium,
                        horizontal: Dimens.marginLarge,
                      )),
                  onPressed: () {
                    if (controller.startTime.value !=
                        controller.endTime.value) {
                      logPrint('log: build ${controller.repeatDays}');
                      controller.addScenario();
                      Navigator.pop(context);
                    } else {
                      Get.rawSnackbar(message: 'Set time first');
                    }
                  },
                  child: const Text(AppConstants.save)),
            )
          ],
        ),
      ),
    );
  }
}
