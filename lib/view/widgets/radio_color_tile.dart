import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/services/theme_services.dart';

class RadioColorTile extends StatefulWidget {
  final MyTheme value;
  final Function(MyTheme value)? onChanged;

  const RadioColorTile({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  State<RadioColorTile> createState() => _RadioColorTileState();
}

class _RadioColorTileState extends State<RadioColorTile> {
  MyTheme? groupValue;
  double radius = 15;

  @override
  void didChangeDependencies() {
    groupValue = _getTheme(ThemeServices.of(context).primary);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
    return RadioListTile(
        value: widget.value,
        groupValue: groupValue,
        title: Text(
          widget.value.title,
          style: TextStyle(color: scheme.textColor),
        ),
        activeColor: scheme.primary,
        secondary: CircleAvatar(
            radius: radius,
            backgroundColor: ColorRes.secondaryLight,
            child: CircleAvatar(
              radius: radius - 4,
              backgroundColor: widget.value.primary,
            )),
        onChanged: (value) {
          setState(() {
            groupValue = value;
          });
          if (widget.onChanged != null && value != null) {
            widget.onChanged!(value);
          }
        });
  }

  MyTheme? _getTheme(Color primary) {
    return MyTheme.values.firstWhereOrNull(
      (element) => element.primary == primary,
    );
  }
}
