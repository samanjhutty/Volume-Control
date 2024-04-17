import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/util/app_constants.dart';
import '../model/models/days_model.dart';
import '../model/util/dimens.dart';

class AddScenario extends StatefulWidget {
  const AddScenario({super.key});

  @override
  State<AddScenario> createState() => _ScenarioState();
}

class _ScenarioState extends State<AddScenario> {
  TextEditingController titleController = TextEditingController(text: '');
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);
  DBcontroller dBcontroller = Get.find();
  late List<bool> daySelected;
  late List<Widget> days;
  List<String> repeatDays = [];
  String volumeMode = AppConstants.volNormal;
  double volume = 0;

  @override
  void initState() {
    days = List.generate(
        Dimens.noOfDays.toInt(), (index) => Text(dayList[index].day));
    daySelected = dBcontroller.daysIsSelected();
    super.initState();
  }

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
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppConstants.startTime,
                                style: TextStyle(color: scheme.onPrimary),
                              ),
                              InkWell(
                                onTap: () async {
                                  startTime = await dBcontroller.myTimePicker(
                                      context: context);
                                  setState(() {});
                                },
                                child: Text(startTime.format(context),
                                    style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontSize: Dimens.fontSuperLarge,
                                        fontWeight: FontWeight.bold)),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppConstants.endTime,
                                style: TextStyle(color: scheme.onPrimary),
                              ),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay time = await dBcontroller
                                      .myTimePicker(context: context);
                                  if (time == startTime) {
                                    Get.rawSnackbar(
                                        message:
                                            'End time cannot be same as start time!');
                                  } else {
                                    endTime = time;
                                  }

                                  setState(() {});
                                },
                                child: Text(endTime.format(context),
                                    style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontSize: Dimens.fontSuperLarge,
                                        fontWeight: FontWeight.bold)),
                              )
                            ]),
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
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Dimens.marginDefault),
                                  child: repeatDays.isEmpty
                                      ? const Text(AppConstants.dayNever)
                                      : repeatDays.length == Dimens.noOfDays
                                          ? const Text(AppConstants.everyday)
                                          : Text((repeatDays
                                                  .toString()
                                                  .replaceAll('[', ''))
                                              .replaceAll(']', '')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimens.paddingDefault,
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ToggleButtons(
                                          fillColor: scheme.primary,
                                          selectedColor: scheme.onPrimary,
                                          renderBorder: false,
                                          borderRadius: BorderRadius.circular(
                                              Dimens.borderRadiusDefault),
                                          onPressed: (index) {
                                            setState(() {
                                              daySelected[index] =
                                                  !daySelected[index];
                                              dayList[index].selected =
                                                  !dayList[index].selected;
                                              repeatDays =
                                                  dBcontroller.daysRepeat();
                                            });
                                          },
                                          isSelected: daySelected,
                                          children: days),
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
                                controller: titleController,
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
                                  RadioMenuButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.marginMedium)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .borderRadiusMediumExtra)))),
                                      value: AppConstants.volNormal,
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                        });
                                      },
                                      child:
                                          const Text(AppConstants.volNormal)),
                                  RadioMenuButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.marginMedium)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .borderRadiusMediumExtra)))),
                                      value: AppConstants.volViberate,
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                          volume = 0;
                                        });
                                      },
                                      child:
                                          const Text(AppConstants.volViberate)),
                                  RadioMenuButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.marginMedium)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .borderRadiusMediumExtra)))),
                                      value: AppConstants.volSilent,
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                          volume = 0;
                                        });
                                      },
                                      child:
                                          const Text(AppConstants.volSilent)),
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
                            Row(
                              children: [
                                Expanded(
                                    child: Slider(
                                        value: volume,
                                        onChanged: (value) {
                                          setState(() {
                                            volume = value;
                                            volumeMode = AppConstants.volNormal;
                                          });
                                        })),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Dimens.paddingDefault),
                                  child: Text(
                                    '${(volume * 100).ceil()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
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
                      if (startTime != const TimeOfDay(hour: 0, minute: 0) ||
                          endTime != const TimeOfDay(hour: 0, minute: 0)) {
                        dBcontroller.addScenario(context,
                            startTime: startTime,
                            endTime: endTime,
                            title: titleController.text,
                            repeat: repeatDays,
                            volumeMode: volumeMode,
                            volume: volume.toInt(),
                            isON: repeatDays.isEmpty ? false : true);
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

  @override
  void dispose() {
    for (int i = 0; i < dayList.length; i++) {
      dayList[i].selected = false;
    }
    super.dispose();
  }
}
