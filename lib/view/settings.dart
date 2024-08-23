import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/model/util/dimens.dart';
import 'package:volume_control/model/util/string_resources.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/services/extension_methods.dart';
import 'package:volume_control/services/theme_services.dart';
import 'package:volume_control/view/widgets/base_widget.dart';
import 'package:volume_control/view/widgets/my_checkbox.dart';
import 'package:volume_control/view/widgets/color_palate_widget.dart';
import 'package:volume_control/view/widgets/radio_color_tile.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';

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
    return BaseWidget(
      color: scheme.background,
      appBar: AppBar(
        backgroundColor: scheme.background,
        foregroundColor: scheme.textColor,
        title: const Text(
          StringRes.settings,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(Dimens.sizeDefault),
        children: [
          const MyText(StringRes.personlize),
          MyCard(
            leading: const Icon(Icons.access_time_filled),
            title: const Text(StringRes.changeTime),
            trailing: MyCheckBox(
              value: services.is24hrFormat.value,
              onChanged: (value) {
                Get.find<AuthServices>().is24hrFormat.value = value;
                Get.find<DBcontroller>().saveTimeFormat(use24Hr: value);
              },
            ),
          ),
          MyCard(
            onTap: () => showModalBottomSheet(
                context: context, builder: (context) => const SelectTheme()),
            leading: const Icon(Icons.color_lens),
            title: const Text(StringRes.changeTheme),
            trailing: MyColorPalete(color: scheme.textColorLight),
          ),
        ],
      ),
    );
  }
}

class SelectTheme extends StatefulWidget {
  const SelectTheme({super.key});

  @override
  State<SelectTheme> createState() => _SelectThemeState();
}

class _SelectThemeState extends State<SelectTheme> {
  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);

    return BottomSheet(
        backgroundColor: scheme.surface,
        onClosing: () {},
        showDragHandle: true,
        dragHandleColor: scheme.disabled,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.sizeDefault),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: MyTheme.values
                      .map((e) => RadioColorTile(
                            value: e,
                            onChanged: (value) {
                              ThemeServices.of(context).changeTheme(value);
                            },
                          ))
                      .toList()));
        });
  }
}

class MyCard extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MyCard(
      {super.key, this.leading, this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);

    return Card(
      color: scheme.disabled.withOpacity(.1),
      surfaceTintColor: scheme.primary,
      shadowColor: Colors.transparent,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: Dimens.sizeSmall),
        textColor: scheme.textColor,
        iconColor: scheme.textColorLight,
        leading: leading,
        title: title,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String text;
  const MyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: Dimens.sizeSmall),
        Text(
          text,
          style: TextStyle(color: scheme.disabled),
        )
      ],
    );
  }
}
