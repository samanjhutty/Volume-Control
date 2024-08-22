import 'package:flutter/material.dart';
import 'package:volume_control/model/util/color_resources.dart';

class MyColorPalete extends StatelessWidget {
  final EdgeInsets? margin;
  final Color? color;
  const MyColorPalete({super.key, this.margin, this.color});

  final double radius = 15;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 6,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: MyTheme.values
            .map(
              (e) => Positioned(
                left: e.index * (radius + 4),
                child: CircleAvatar(
                    radius: radius,
                    backgroundColor: color ?? ColorRes.secondaryLight,
                    child: CircleAvatar(
                      radius: radius - 4,
                      backgroundColor: e.primary,
                    )),
              ),
            )
            .toList(),
      ),
    );
  }
}
