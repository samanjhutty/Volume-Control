import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/string_resources.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/view/widgets/checkbox_tile.dart';

import '../model/util/color_resources.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    AuthServices services = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: const Text(StringRes.settings),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text(StringRes.changeTime),
              trailing: MyCheckBox(value: services.is24hrFormat.value),
            ),
            ListTile(
              title: const Text(StringRes.changeTheme),
              trailing: CircleAvatar(
                  radius: 15,
                  backgroundColor: ColorRes.secondary,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  )),
            )
          ],
        ));
  }
}
