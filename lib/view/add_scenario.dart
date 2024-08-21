import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/view/widgets/checkbox_tile.dart';
import 'package:volume_control/view/widgets/time_picker.dart';
import 'package:volume_control/view_model/controllers/add_scenario_controller.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/util/string_resources.dart';
import '../model/util/dimens.dart';
import '../services/theme_services.dart';

class AddScenario extends GetView<AddScenarioController> {
  const AddScenario({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
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
                  icon: const Icon(
                    Icons.delete,
                    color: ColorRes.onErrorContainer,
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
                          Text(
                            StringRes.startTime,
                            style: TextStyle(
                                color: scheme.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.fontLarge),
                          ),
                          const SizedBox(height: Dimens.sizeSmall),
                          MyTimePicker(
                            color: scheme.textColor,
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
                          Text(
                            StringRes.endTime,
                            style: TextStyle(
                                color: scheme.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.fontLarge),
                          ),
                          const SizedBox(height: Dimens.sizeSmall),
                          MyTimePicker(
                            color: scheme.textColor,
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
                  color: scheme.background,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimens.borderRadiusLarge))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimens.sizeSmall),
                    Text(
                      StringRes.repeat,
                      style: TextStyle(
                          color: scheme.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.fontLarge),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimens.sizeSmall),
                          child: Obx(() => Text(
                                db.repeatDaysText(controller.repeatDays),
                                style: TextStyle(color: scheme.textColor),
                              )),
                        ),
                        const SizedBox(height: Dimens.sizeSmall),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx(
                              () => ToggleButtons(
                                  fillColor: scheme.onPrimaryContainer,
                                  selectedColor: scheme.primaryContainer,
                                  color: scheme.textColor,
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
                      cursorColor: scheme.primary,
                      decoration: InputDecoration(
                          floatingLabelStyle:
                              TextStyle(color: scheme.onPrimaryContainer),
                          labelText: StringRes.sceName,
                          labelStyle:
                              TextStyle(color: scheme.textColorDisabled),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: scheme.textColorDisabled)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: scheme.onPrimaryContainer))),
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
                    Text(StringRes.volMode,
                        style: TextStyle(
                            color: scheme.textColor,
                            fontSize: Dimens.fontLarge,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: Dimens.sizeDefault),
                    Row(
                      children: RingerModeStatus.values
                          .map((e) => e.index == 0
                              ? const SizedBox()
                              : Expanded(
                                  child: RadioTheme(
                                    data: RadioTheme.of(context).copyWith(
                                        fillColor: MaterialStatePropertyAll(
                                            scheme.primary)),
                                    child: Obx(
                                      () => RadioMenuButton(
                                          style: _radioButtonStyle(context),
                                          value: e.name,
                                          groupValue:
                                              controller.volumeMode.value,
                                          onChanged: (value) {
                                            controller.volumeMode.value =
                                                value!;
                                          },
                                          child: Text(e.name.capitalize!)),
                                    ),
                                  ),
                                ))
                          .toList(),
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
                    Text(StringRes.vol,
                        style: TextStyle(
                            color: scheme.textColor,
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
                        Text(
                          StringRes.changeVol,
                          style: TextStyle(color: scheme.textColor),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimens.sizeDefault),
                    SliderTheme(
                      data: SliderThemeData(
                          disabledThumbColor: scheme.textColorDisabled,
                          disabledActiveTrackColor: Colors.grey,
                          disabledInactiveTrackColor:
                              scheme.textColorDisabled.withOpacity(0.5)),
                      child: Obx(
                        () => Row(
                          children: [
                            Expanded(
                                child: Slider(
                                    inactiveColor: scheme.textColorLight,
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: scheme.textColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          )),
        ],
      ),
      bottomNavigationBar: Container(
        color: scheme.background,
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

  ButtonStyle _radioButtonStyle(BuildContext context) {
    return IconButton.styleFrom(
        foregroundColor: ThemeServices.of(context).textColor,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.sizeDefault),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.borderRadiusMediumExtra))));
  }
}
