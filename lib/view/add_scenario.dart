import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/assets/dimens.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import '../model/days_model.dart';

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
  String volumeMode = 'Normal';
  double volume = 0;

  @override
  void initState() {
    days = List.generate(7, (index) => Text(dayList[index].day));
    daySelected = dBcontroller.daysIsSelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
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
                                'Start Time',
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
                                        fontSize: Dimens.fontxLarge,
                                        fontWeight: FontWeight.bold)),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'End Time',
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
                                        fontSize: Dimens.fontxLarge,
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
                              top: Radius.circular(Dimens.borderRadius))),
                      child: ListView(
                          padding: const EdgeInsets.all(Dimens.xMargin),
                          children: [
                            const Text(
                              'Repeat',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimens.fontLarge),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(Dimens.margin),
                                  child: repeatDays.isEmpty
                                      ? const Text(
                                          'Never',
                                        )
                                      : repeatDays.length == 7
                                          ? const Text('Everyday')
                                          : Text((repeatDays
                                                  .toString()
                                                  .replaceAll('[', ''))
                                              .toString()
                                              .replaceAll(']', '')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ToggleButtons(
                                          fillColor: scheme.primary,
                                          selectedColor: scheme.onPrimary,
                                          renderBorder: false,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                vertical: 16,
                              ),
                              child: TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Scenario Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('Mode',
                                  style: TextStyle(
                                      fontSize: Dimens.fontLarge,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                                          Dimens.xMargin)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24)))),
                                      value: 'Normal',
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                        });
                                      },
                                      child: const Text('Normal')),
                                  RadioMenuButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.xMargin)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24)))),
                                      value: 'Viberate',
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                          volume = 0;
                                        });
                                      },
                                      child: const Text('Viberate')),
                                  RadioMenuButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.xMargin)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24)))),
                                      value: 'Silent',
                                      groupValue: volumeMode,
                                      onChanged: (value) {
                                        setState(() {
                                          volumeMode = value!;
                                          volume = 0;
                                        });
                                      },
                                      child: const Text('Silent')),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('Volume',
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
                                            volumeMode = 'Normal';
                                          });
                                        })),
                                Padding(
                                  padding: const EdgeInsets.all(8),
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
            padding: const EdgeInsets.symmetric(vertical: Dimens.xMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                      vertical: Dimens.xMargin,
                      horizontal: Dimens.xlMargin,
                    )),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: scheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.xMargin,
                          horizontal: Dimens.xlMargin,
                        )),
                    onPressed: () {
                      if (startTime != const TimeOfDay(hour: 0, minute: 0) ||
                          endTime != const TimeOfDay(hour: 0, minute: 0)) {
                        dBcontroller.addScenario(
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
                    child: const Text('Save'))
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
