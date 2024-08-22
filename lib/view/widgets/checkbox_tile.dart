import 'package:flutter/material.dart';
import 'package:volume_control/services/theme_services.dart';

class MyCheckBox extends StatefulWidget {
  final bool value;
  final Function(bool? value)? onChanged;
  const MyCheckBox({super.key, required this.value, this.onChanged});

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = ThemeServices.of(context);
    return Checkbox(
      side: BorderSide(color: scheme.textColorDisabled, width: 2),
      activeColor: scheme.primary,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
