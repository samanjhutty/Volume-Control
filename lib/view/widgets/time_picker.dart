import 'package:flutter/material.dart';
import '../../model/util/dimens.dart';

class MyTimePicker extends StatefulWidget {
  final int? itemExtent;
  final double? height;
  final double? heightFactor;
  final double? extentFactor;
  final int? visibleChildren;
  final TextStyle? textStyle;
  final Color? color;
  final double? unselectedItemOpacity;
  final TimeOfDay initalTime;
  final Function(TimeOfDay time) onChanged;

  const MyTimePicker({
    super.key,
    this.itemExtent,
    this.textStyle,
    this.color,
    this.unselectedItemOpacity,
    this.extentFactor,
    this.heightFactor,
    this.visibleChildren,
    required this.initalTime,
    required this.onChanged,
    this.height,
  })  : assert(unselectedItemOpacity == null ||
            unselectedItemOpacity <= 1 && unselectedItemOpacity >= 0),
        assert(extentFactor == null || extentFactor > 0 && extentFactor < 0.05),
        assert(heightFactor == null || heightFactor > 0 && heightFactor < 0.1);

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  FixedExtentScrollController hourController = FixedExtentScrollController();
  FixedExtentScrollController minController = FixedExtentScrollController();
  late int itemExtent;
  late int visibleChildren;
  late double unselecOpacity;
  late TextStyle textStyle;
  double fontSize = Dimens.fontSuperLarge;

  @override
  void initState() {
    itemExtent = widget.itemExtent ?? 50;
    visibleChildren = (widget.visibleChildren ?? 1) + 1;
    unselecOpacity = widget.unselectedItemOpacity ?? 0.2;
    _extentFactor = widget.extentFactor ?? 0.026;
    _heightFactor = widget.heightFactor ?? 0.0416;

    textStyle = widget.textStyle ??
        TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: widget.color);

    // calclaions based on values provided
    _itemExtent = itemExtent * (textStyle.fontSize ?? fontSize) * _extentFactor;
    _itemWidth = (textStyle.fontSize ?? fontSize) * 2;
    _widgetHeight = itemExtent *
        (textStyle.fontSize ?? fontSize) *
        visibleChildren *
        _heightFactor;

    Future(() => _setInitialTime()).then((value) => setState(() {}));
    super.initState();
  }

  late double _itemExtent;
  late double _itemWidth;
  late double _widgetHeight;
  late double _extentFactor;
  late double _heightFactor;

  _setInitialTime() async {
    const duration = Duration(seconds: 1);
    hourController.animateToItem(widget.initalTime.hour,
        duration: duration, curve: Curves.easeOut);

    minController.animateToItem(widget.initalTime.minute,
        duration: duration, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? _widgetHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _itemWidth,
            child: ListWheelScrollView.useDelegate(
              itemExtent: _itemExtent,
              magnification: 1.2,
              controller: hourController,
              physics: const FixedExtentScrollPhysics(),
              overAndUnderCenterOpacity: unselecOpacity,
              childDelegate: ListWheelChildLoopingListDelegate(
                  children: List.generate(24, (index) {
                return Text(_format(index), style: textStyle);
              })),
              onSelectedItemChanged: (value) {
                widget.onChanged(TimeOfDay(
                    hour: hourController.selectedItem,
                    minute: minController.selectedItem));
              },
            ),
          ),
          Text(':', style: textStyle),
          SizedBox(
            width: _itemWidth,
            child: ListWheelScrollView.useDelegate(
              itemExtent: _itemExtent,
              controller: minController,
              magnification: 1.2,
              physics: const FixedExtentScrollPhysics(),
              overAndUnderCenterOpacity: unselecOpacity,
              childDelegate: ListWheelChildLoopingListDelegate(
                  children: List.generate(60, (index) {
                return Text(_format(index), style: textStyle);
              })),
              onSelectedItemChanged: (value) {
                widget.onChanged(TimeOfDay(
                    hour: hourController.selectedItem,
                    minute: minController.selectedItem));
              },
            ),
          ),
        ],
      ),
    );
  }

  String _format(int count) {
    return count < 10 ? '0$count' : count.toString();
  }
}
