import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/add_scenario_controller.dart';
import 'package:volume_control/model/util/app_constants.dart';
import '../model/util/dimens.dart';

class AddScenario extends GetView<AddScenarioController> {
  const AddScenario({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
          ),
          body: ColoredBox(
            color: scheme.primary,
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
                                  style: TextStyle(color: scheme.onPrimary),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.startTime.value =
                                        await controller.myTimePicker(
                                            context: context);
                                  },
                                  child: Text(
                                      controller.startTime.value
                                          .format(context),
                                      style: TextStyle(
                                          color: scheme.onPrimary,
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
                                  style: TextStyle(color: scheme.onPrimary),
                                ),
                                InkWell(
                                  onTap: () async {
                                    TimeOfDay time = await controller
                                        .myTimePicker(context: context);
                                    if (time == controller.startTime.value) {
                                      Get.rawSnackbar(
                                          message:
                                              'End time cannot be same as start time!');
                                    } else {
                                      controller.endTime.value = time;
                                    }
                                  },
                                  child: Text(
                                      controller.endTime.value.format(context),
                                      style: TextStyle(
                                          color: scheme.onPrimary,
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
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(Dimens.borderRadiusLarge))),
                      child: ListView(
                          padding: const EdgeInsets.all(Dimens.marginMedium),
                          children: [
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
                                    padding: const EdgeInsets.all(
                                        Dimens.marginDefault),
                                    child: controller.repeatDays.isEmpty
                                        ? const Text(AppConstants.dayNever)
                                        : controller.repeatDays.length ==
                                                Dimens.noOfDays
                                            ? const Text(AppConstants.everyday)
                                            : Text((controller.repeatDays
                                                    .toString()
                                                    .replaceAll('[', ''))
                                                .replaceAll(']', '')),
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
                                            fillColor: scheme.primary,
                                            selectedColor: scheme.onPrimary,
                                            renderBorder: false,
                                            borderRadius: BorderRadius.circular(
                                                Dimens.borderRadiusDefault),
                                            onPressed: (index) {
                                              controller.daySelected[index] =
                                                  !controller
                                                      .daySelected[index];
                                              controller
                                                      .dayList[index].selected =
                                                  !controller
                                                      .dayList[index].selected;
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
                                decoration: const InputDecoration(
                                  labelText: AppConstants.sceName,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: Dimens.paddingDefault),
                              child: Text(AppConstants.volMode,
                                  style: TextStyle(
                                      fontSize: Dimens.fontLarge,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.paddingMedium),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(
                                    () => RadioMenuButton(
                                        style: ButtonStyle(
                                            padding:
                                                const MaterialStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: Dimens
                                                            .marginMedium)),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimens
                                                            .borderRadiusMediumExtra)))),
                                        value: AppConstants.volNormal,
                                        groupValue: controller.volumeMode.value,
                                        onChanged: (value) {
                                          controller.volumeMode.value = value!;
                                        },
                                        child:
                                            const Text(AppConstants.volNormal)),
                                  ),
                                  Obx(
                                    () => RadioMenuButton(
                                        style: ButtonStyle(
                                            padding:
                                                const MaterialStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: Dimens
                                                            .marginMedium)),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimens
                                                            .borderRadiusMediumExtra)))),
                                        value: AppConstants.volViberate,
                                        groupValue: controller.volumeMode.value,
                                        onChanged: (value) {
                                          controller.volumeMode.value = value!;
                                          controller.volume.value = 0;
                                        },
                                        child: const Text(
                                            AppConstants.volViberate)),
                                  ),
                                  Obx(
                                    () => RadioMenuButton(
                                        style: ButtonStyle(
                                            padding:
                                                const MaterialStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: Dimens
                                                            .marginMedium)),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimens
                                                            .borderRadiusMediumExtra)))),
                                        value: AppConstants.volSilent,
                                        groupValue: controller.volumeMode.value,
                                        onChanged: (value) {
                                          controller.volumeMode.value = value!;
                                          controller.volume.value = 0;
                                        },
                                        child:
                                            const Text(AppConstants.volSilent)),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: Dimens.paddingDefault),
                              child: Text(AppConstants.vol,
                                  style: TextStyle(
                                      fontSize: Dimens.fontLarge,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                      child: Slider(
                                          value: controller.volume.value,
                                          onChanged: (value) {
                                            controller.volume.value = value;
                                            controller.volumeMode.value =
                                                AppConstants.volNormal;
                                          })),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        Dimens.paddingDefault),
                                    child: Text(
                                      '${(controller.volume.value * 100).ceil()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.marginMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                      vertical: Dimens.marginMedium,
                      horizontal: Dimens.marginLarge,
                    )),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(AppConstants.cancel)),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: scheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.marginMedium,
                          horizontal: Dimens.marginLarge,
                        )),
                    onPressed: () {
                      if (controller.startTime.value !=
                              const TimeOfDay(hour: 0, minute: 0) ||
                          controller.endTime.value !=
                              const TimeOfDay(hour: 0, minute: 0)) {
                        controller.addScenario(context);
                        Navigator.pop(context);
                      } else {
                        Get.rawSnackbar(message: 'Set time first');
                      }
                    },
                    child: const Text(AppConstants.save))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
