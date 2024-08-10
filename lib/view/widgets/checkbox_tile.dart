import 'package:flutter/material.dart';

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
    return Checkbox(
      visualDensity: VisualDensity.compact,
      value: value,
      splashRadius: 5,
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
