import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/controller/add_scenario_controller.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/util/app_constants.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.settings),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => CheckboxListTile(
            value: Get.find<DBcontroller>().is24hrFormat.value,
            onChanged: (value) {
              Get.find<DBcontroller>().is24hrFormat.value = value ?? false;
              box.put(AppConstants.is24hr, value);
            },
            title: const Text('Use 24hr format'),
          ),
        ),
      ),
    );
  }
}
