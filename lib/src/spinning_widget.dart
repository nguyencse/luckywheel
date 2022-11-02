import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luckywheel/src/utils/wheel_debug.dart';

class SpinningWidget extends StatefulWidget {
  const SpinningWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.totalParts,
    this.initAngle,
  }) : super(key: key);

  final double width;
  final double height;
  final int totalParts;
  final double? initAngle;

  @override
  State<SpinningWidget> createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<SpinningWidget> {
  int _totalParts = 0;
  double _angleEachPart = 0.0;
  double _initAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _totalParts = widget.totalParts > 0 ? widget.totalParts : 1; // to avoid zero division
    _angleEachPart = 2 * pi / _totalParts;
    _initAngle = widget.initAngle ?? (_angleEachPart / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.width / 2),
            color: Colors.red,
          ),
        ),
        ...List.generate(
          widget.totalParts,
          (idx) {
            WheelDebug.log('color: $idx: ${idx % 2 == 0 ? "yellow" : "red"}');
            return CustomPaint(
              size: const Size(300, 300),
              painter: PiceOfCakePainter(
                bgColor: idx == 0 ? Colors.red : (idx % 2 == 0 ? Colors.yellow : Colors.green),
                startAngle: _angleEachPart * idx - pi / 2 - _initAngle,
                sweepAngle: _angleEachPart,
              ),
            );
          },
        ),
      ],
    );
  }
}

class PiceOfCakePainter extends CustomPainter {
  const PiceOfCakePainter({this.startAngle, this.sweepAngle, this.bgColor});

  final Color? bgColor;
  final double? startAngle;
  final double? sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = bgColor ?? Colors.yellow;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      startAngle ?? pi,
      sweepAngle ?? pi,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
