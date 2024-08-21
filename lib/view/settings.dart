import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/model/util/dimens.dart';
import 'package:volume_control/model/util/string_resources.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/services/theme_services.dart';
import 'package:volume_control/view/widgets/checkbox_tile.dart';
import 'package:volume_control/view/widgets/color_palate_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthServices services = Get.find();

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
    return Scaffold(
        backgroundColor: scheme.background,
        appBar: AppBar(
          backgroundColor: scheme.background,
          foregroundColor: scheme.textColor,
          title: const Text(StringRes.settings),
        ),
        body: ListView(
          children: [
            ListTile(
              textColor: scheme.textColor,
              iconColor: scheme.textColorLight,
              leading: const Icon(Icons.access_time_filled),
              title: const Text(StringRes.changeTime),
              trailing: MyCheckBox(value: services.is24hrFormat.value),
            ),
            const MyDivider(),
            ListTile(
              textColor: scheme.textColor,
              iconColor: scheme.textColorLight,
              onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSheet(
                      backgroundColor: scheme.surface,
                      onClosing: () {},
                      showDragHandle: true,
                      dragHandleColor: scheme.textColor,
                      builder: (context) {
                        double radius = 15;
                        return Padding(
                          padding: const EdgeInsets.all(Dimens.sizeDefault),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: MyTheme.values
                                  .map((e) => ListTile(
                                        onTap: () => ThemeServices.of(context)
                                            .changeTheme(e),
                                        title: Text(
                                          e.title,
                                          style: TextStyle(
                                              color: scheme.textColor),
                                        ),
                                        trailing: CircleAvatar(
                                            radius: radius,
                                            backgroundColor:
                                                ColorRes.secondaryLight,
                                            child: CircleAvatar(
                                              radius: radius - 4,
                                              backgroundColor: e.primary,
                                            )),
                                      ))
                                  .toList()),
                        );
                      })),
              leading: const Icon(Icons.color_lens),
              title: const Text(StringRes.changeTheme),
              trailing: MyColorPalete(color: scheme.textColorLight),
            ),
            const MyDivider(),
          ],
        ));
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: Dimens.sizeLarge, left: Dimens.sizeDefault),
      child: Divider(
        color: ThemeServices.of(context).surface,
      ),
    );
  }
}
