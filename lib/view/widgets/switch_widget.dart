import 'package:flutter/material.dart';

class MySwitchWidget extends StatefulWidget {
  final bool value;
  final Function(bool value)? onChanged;
  const MySwitchWidget({super.key, required this.value, this.onChanged});

  @override
  State<MySwitchWidget> createState() => MySwitchWidgetState();
}

class MySwitchWidgetState extends State<MySwitchWidget> {
  late bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Switch.adaptive(
      activeColor: scheme.primaryContainer,
      activeTrackColor: scheme.onPrimaryContainer,
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      value: value,
    );
  }
}
