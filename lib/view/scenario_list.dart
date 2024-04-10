import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/scenario_model.dart';
import 'package:volume_control/model/util/app_constants.dart';
import '../model/util/dimens.dart';

class ScenarioList extends StatefulWidget {
  const ScenarioList({super.key});

  @override
  State<ScenarioList> createState() => _ScenarioListState();
}

class _ScenarioListState extends State<ScenarioList> {
  DBcontroller db = Get.find();
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
        child: GetBuilder<DBcontroller>(builder: (db) {
          return scenarioList.isEmpty
              ? Center(
                  child: Text(
                    'Click on + icon to add scenarios',
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                )
              : ListView.builder(
                  itemCount: scenarioList.length,
                  itemBuilder: (context, index) {
                    ScenarioModel list = scenarioList[index];
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
                                    : list.repeat.length == Dimens.everyday
                                        ? const Text(AppConstants.everyday)
                                        : Text((list.repeat
                                                .toString()
                                                .replaceAll('[', ''))
                                            .replaceAll(']', '')),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${list.startTime.format(context)} - ${list.endTime.format(context)}',
                                  style: const TextStyle(
                                      fontSize: Dimens.fontMed,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.phone_android),
                                    const SizedBox(width: Dimens.marginDefault),
                                    Switch.adaptive(
                                      onChanged: (value) {
                                        setState(() {
                                          list.isON = value;
                                        });
                                      },
                                      value: list.isON,
                                    ),
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
