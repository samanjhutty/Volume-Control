import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/view/widgets/my_checkbox.dart';
import 'package:volume_control/view/widgets/time_picker.dart';
import 'package:volume_control/view_model/controllers/add_scenario_controller.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/util/string_resources.dart';
import '../../model/util/dimens.dart';
import '../../services/theme_services.dart';

class AddScenario extends GetView<AddScenarioController> {
  const AddScenario({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
    Size size = MediaQuery.sizeOf(context);
    var device = MediaQuery.orientationOf(context);
    var db = Get.find<DBcontroller>();
    var services = Get.find<AuthServices>();

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            scrolledUnderElevation: 0,
            primary: true,
            expandedHeight: device == Orientation.landscape
                ? size.height * .6
                : size.height * .3,
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
                            use24HrFormat: services.is24hrFormat.value,
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
                            use24HrFormat: services.is24hrFormat.value,
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
              child: SafeArea(
                top: false,
                bottom: false,
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
                          const MyToggleButton()
                        ],
                      ),
                      const SizedBox(height: Dimens.sizeMedium),
                      TextFormField(
                        controller: controller.titleController,
                        cursorColor: scheme.primaryContainer,
                        style: TextStyle(color: scheme.textColor),
                        decoration: InputDecoration(
                            floatingLabelStyle:
                                TextStyle(color: scheme.onPrimaryContainer),
                            labelText: StringRes.sceName,
                            labelStyle: TextStyle(color: scheme.disabled),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: scheme.disabled)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: scheme.onPrimaryContainer))),
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
                                    child: Obx(
                                      () => RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        // style: _radioButtonStyle(context),
                                        value: e.name,
                                        activeColor: scheme.onPrimaryContainer,

                                        visualDensity: VisualDensity.compact,
                                        title: Text(e.name.capitalize!,
                                            style: TextStyle(
                                                color: scheme.textColor)),
                                        groupValue: controller.volumeMode.value,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          controller.volumeMode.value = value;
                                        },
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
                                controller.changeVolume.value = value;
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
                            disabledThumbColor: scheme.disabled,
                            disabledActiveTrackColor: Colors.grey,
                            disabledInactiveTrackColor:
                                scheme.disabled.withOpacity(0.1)),
                        child: Obx(
                          () => Row(
                            children: [
                              Expanded(
                                  child: Slider(
                                      inactiveColor:
                                          scheme.disabled.withOpacity(.1),
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
            ),
          )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: scheme.background,
        surfaceTintColor: scheme.primary,
        padding: EdgeInsets.zero,
        elevation: 8,
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
}

class MyToggleButton extends StatefulWidget {
  const MyToggleButton({super.key});

  @override
  State<MyToggleButton> createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  var controller = Get.find<AddScenarioController>();

  bool isSelected(ScenarioDay element) {
    int index = controller.dayList.indexWhere((e) => e.day == element.day);

    return controller.dayList[index].selected;
  }

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: controller.dayList
            .map((element) => IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        isSelected(element) ? scheme.primaryContainer : null,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(Dimens.sizeSmall + 4),
                    splashFactory: NoSplash.splashFactory),
                onPressed: () {
                  controller.dayList
                      .firstWhere((e) => e.day == element.day)
                      .selected = !isSelected(element);
                  setState(() {});

                  controller.repeatDays.value = controller.daysRepeat();
                },
                icon: Text(
                  element.day,
                  style: TextStyle(
                      color: isSelected(element)
                          ? scheme.onPrimaryContainer
                          : scheme.textColor),
                )))
            .toList());
  }
}
