import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luckywheel/src/utils/wheel_debug.dart';

class LuckyWheelController {
  static const int kDefaultTotalPart = 8;
  static const int kRotateDuration = 2000;
  static const int kStopDuration = 8000;

  final TickerProvider vsync;

  /// [rotateDuration] duration of 1 cycle rotation.
  late final int rotateDuration;

  /// [stopDuration] duration of stopping rotation.
  late final int stopDuration;

  /// [_rotateCtrl] is the controller to handle infinity rotation.
  late final AnimationController _rotateCtrl;
  late final Animation<double> _rotateAnim;

  /// [_stopCtrl] is the controller to handle infinity rotation.
  late final AnimationController _stopCtrl;
  late final Animation<double> _stopAnim;

  /// [onRotationEnd] callback after rotation ended. It will invoke with an index of the selected part.
  final Function(int)? onRotationEnd;

  /// [totalParts] total parts of the wheels
  final int totalParts;

  /// [_accelerate] this is the friction we use while stopping the wheel.
  double _accelerate = 0.0;

  /// [_selectedIndex] this is the selected index that we want to stopped at.
  int _selectedIndex = 0;

  /// [_selectedAngle] this is the selected angle of its index (count from 0) in radian mode.
  double _selectedAngle = 0.0;

  /// [_angleEachPart] angle each part of the wheel.
  double _angleEachPart = 0.0;

  /// [_speed] speed of rotation
  double _speed = 1;

  bool _isFirstStop = false;
  bool _isStopPressed = false;

  Animation<double> get rotateAnim => _rotateAnim;

  LuckyWheelController({
    required this.vsync,
    required this.totalParts,
    this.onRotationEnd,
    this.rotateDuration = kRotateDuration,
    this.stopDuration = kStopDuration,
  }) {
    _angleEachPart = 2 * pi / totalParts;
    _speed = stopDuration / rotateDuration;

    _rotateCtrl = AnimationController(
        vsync: vsync, duration: Duration(milliseconds: rotateDuration));
    _rotateAnim = Tween(begin: 0.0, end: 1.0).animate(_rotateCtrl);

    _stopCtrl = AnimationController(
        vsync: vsync, duration: Duration(milliseconds: stopDuration));
    _stopAnim = Tween(begin: 0.0, end: 0.5).animate(_stopCtrl);

    _rotateCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WheelDebug.log('completed 1 circulation');
        if (!_isStopPressed) {
          _rotateCtrl.forward(from: 0);
        } else {
          if (_isFirstStop && _stopCtrl.value == 0.0) {
            _rotateCtrl.duration = _stopCtrl.duration;
            _speed = _speed * stopDuration / rotateDuration;
            _stopCtrl.forward();
            _isFirstStop = false;
          }
          if (_stopCtrl.isAnimating) {
            _rotateCtrl.forward(from: 0);
          }
        }
      }
    });

    _stopCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotateCtrl.stop();
        _stopCtrl.stop();
        WheelDebug.log('_selectedIndex: $_selectedIndex');
        onRotationEnd?.call(_selectedIndex);
      }
    });

    _stopAnim.addListener(() {
      var x = _stopAnim.value;
      _accelerate = x * sin(pi * x);
      WheelDebug.log('_stopX: $x');
      WheelDebug.log('_stopValue: $_accelerate');
    });
  }

  void reset() {
    WheelDebug.log('reset');
    _rotateCtrl.stop();
    _rotateCtrl.reset();
    _stopCtrl.stop();
    _stopCtrl.reset();
    _accelerate = 0.0;
    _isFirstStop = false;
    _isStopPressed = false;
    _selectedIndex = 0;
    _selectedAngle = 0.0;
    _speed = stopDuration / rotateDuration;
    _rotateCtrl.duration = Duration(milliseconds: rotateDuration);
  }

  void start() {
    if (_rotateCtrl.isAnimating) return;

    WheelDebug.log('start');
    _rotateCtrl.forward(from: 0);
  }

  void stop({int? atIndex}) {
    if (_stopCtrl.isAnimating) return;

    if (atIndex != null && (atIndex < 0 || atIndex >= totalParts)) {
      WheelDebug.log('atIndex must be in [0;$totalParts)');
      return;
    }

    WheelDebug.log('stop');
    _isFirstStop = true;
    _isStopPressed = true;
    _selectedIndex = atIndex ?? Random().nextInt(totalParts);
    var randomAngleAPart = Random().nextDouble() * (_angleEachPart / 2.2);
    _selectedAngle = _selectedIndex * _angleEachPart + randomAngleAPart;
  }

  double calcAngle() {
    return _rotateAnim.value * 2 * pi * _speed * (1 - _accelerate) +
        _selectedAngle -
        (1 - _stopCtrl.value) * (1 - _stopCtrl.value) * _selectedAngle;
  }

  bool get isAnimating => _rotateCtrl.isAnimating || _stopCtrl.isAnimating;
}
