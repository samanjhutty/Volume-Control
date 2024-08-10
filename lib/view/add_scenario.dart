import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/view/widgets/checkbox_tile.dart';
import 'package:volume_control/view/widgets/time_picker.dart';
import 'package:volume_control/view_model/controllers/add_scenario_controller.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/util/string_resources.dart';
import '../model/util/dimens.dart';

class AddScenario extends GetView<AddScenarioController> {
  const AddScenario({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    var db = Get.find<DBcontroller>();
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            scrolledUnderElevation: 0,
            primary: true,
            expandedHeight: MediaQuery.sizeOf(context).height * .35,
            collapsedHeight: kToolbarHeight,
            pinned: true,
            actions: [
              IconButton(
                  onPressed: controller.updateList != null
                      ? () => controller.deleteScenario()
                      : () => Get.back(),
                  icon: Icon(
                    Icons.delete,
                    color: scheme.error,
                  ))
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            StringRes.startTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.fontLarge),
                          ),
                          const SizedBox(height: Dimens.sizeSmall),
                          MyTimePicker(
                            initalTime: controller.startTime ??
                                TimeOfDay.fromDateTime(DateTime.now()),
                            onChanged: (time) {
                              controller.startTime = time;
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            StringRes.endTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.fontLarge),
                          ),
                          const SizedBox(height: Dimens.sizeSmall),
                          MyTimePicker(
                            initalTime: controller.endTime ??
                                TimeOfDay.fromDateTime(DateTime.now()
                                    .add(const Duration(hours: 2))),
                            onChanged: (time) {
                              controller.endTime = time;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: ColoredBox(
            color: scheme.primaryContainer,
            child: Container(
              padding: const EdgeInsets.all(Dimens.sizeDefault),
              decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimens.borderRadiusLarge))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimens.sizeSmall),
                    const Text(
                      StringRes.repeat,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.fontLarge),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimens.sizeSmall),
                          child: Obx(() =>
                              Text(db.repeatDaysText(controller.repeatDays))),
                        ),
                        const SizedBox(height: Dimens.sizeSmall),
                        Center(
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
                                      controller.dayList[index].selected = true;
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
                        )
                      ],
                    ),
                    const SizedBox(height: Dimens.sizeMedium),
                    TextFormField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: scheme.onSurface),
                          labelText: StringRes.sceName,
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: scheme.onPrimaryContainer))),
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
                    const Text(StringRes.volMode,
                        style: TextStyle(
                            fontSize: Dimens.fontLarge,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: Dimens.sizeDefault),
                    Row(
                      children: RingerModeStatus.values
                          .map((e) => e.index == 0
                              ? const SizedBox()
                              : Expanded(
                                  child: Obx(
                                    () => RadioMenuButton(
                                        style: _radioButtonStyle(),
                                        value: e.name,
                                        groupValue: controller.volumeMode.value,
                                        onChanged: (value) {
                                          controller.volumeMode.value = value!;
                                        },
                                        child: Text(e.name.capitalize!)),
                                  ),
                                ))
                          .toList(),
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
                    const Text(StringRes.vol,
                        style: TextStyle(
                            fontSize: Dimens.fontLarge,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: Dimens.sizeSmall),
                    Row(
                      children: [
                        MyCheckBox(
                            value: controller.changeVolume.value,
                            onChanged: (value) {
                              controller.changeVolume.value = value ?? false;
                            }),
                        const Text(StringRes.changeVol)
                      ],
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
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
                            padding: const EdgeInsets.all(Dimens.sizeSmall),
                            child: Text(
                              '${(controller.volume.value * 100).ceil()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          )),
        ],
      ),
      bottomNavigationBar: Container(
        color: scheme.surface,
        padding: const EdgeInsets.only(bottom: Dimens.sizeSmall),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: scheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.sizeDefault,
                        horizontal: Dimens.sizeMediumLarge,
                      )),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(StringRes.cancel)),
            ),
            const SizedBox(height: Dimens.sizeSmall),
            Expanded(
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: scheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.sizeDefault,
                        horizontal: Dimens.sizeMediumLarge,
                      )),
                  onPressed: () {
                    if (controller.startTime == controller.endTime) {
                      showToast(StringRes.errorSetTime);
                      return;
                    }
                    controller.addScenario();
                    Navigator.pop(context);
                  },
                  child: const Text(StringRes.save)),
            )
          ],
        ),
      ),
    );
  }

  ButtonStyle _radioButtonStyle() {
    return IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.sizeDefault),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.borderRadiusMediumExtra))));
  }
}
