import 'package:flutter/material.dart';
import 'package:luckywheel/src/utils/lucky_wheel_controller.dart';
import 'package:luckywheel/src/utils/wheel_debug.dart';

class LuckyWheel extends StatelessWidget {
  const LuckyWheel({
    Key? key,
    required this.controller,
    required this.onResult,
    this.child,
  }) : super(key: key);
  final LuckyWheelController controller;
  final Function(int) onResult;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.rotateAnim,
      builder: (_, child) {
        var angle = controller.calcAngle();
        WheelDebug.log('value: ${controller.rotateAnim.value}');
        WheelDebug.log('angle: $angle');
        return Transform.rotate(
          angle: angle,
          child: child,
        );
      },
      child: child ?? const SizedBox(),
    );
  }
}
