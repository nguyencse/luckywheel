import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LuckyWheelController {
  static const int kDefaultTotalPart = 8;

  final TickerProvider vsync;

  late final AnimationController _rotateCtrl;
  late final Animation<double> _rotateAnim;

  late final AnimationController _stopCtrl;
  late final Animation<double> _stopAnim;

  final Function(int)? onRotationEnd;
  final int totalParts;

  bool _isFirstStop = false;
  bool _isStopPressed = false;
  double _accelerate = 0.0;
  double _selectedAngle = 0.0;
  int _selectedIndex = 0;
  int _totalParts = 0;
  double _angleEachPart = 0.0;

  static const int _rotateDuration = 2000;
  static const int _stopDuration = 8000;
  double _speed = _stopDuration / _rotateDuration;

  Animation<double> get rotateAnim => _rotateAnim;

  var data = [];

  LuckyWheelController({required this.vsync, this.onRotationEnd, this.totalParts = 0}) {
    _totalParts = 8;
    _angleEachPart = 2 * pi / _totalParts;

    _rotateCtrl = AnimationController(vsync: vsync, duration: const Duration(milliseconds: _rotateDuration));
    _rotateAnim = Tween(begin: 0.0, end: 1.0).animate(_rotateCtrl);

    _stopCtrl = AnimationController(vsync: vsync, duration: const Duration(milliseconds: _stopDuration));
    _stopAnim = Tween(begin: 0.0, end: 0.5).animate(_stopCtrl);

    _rotateCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WheelDebug.log('completed 1 circulation');
        if (!_isStopPressed) {
          _rotateCtrl.forward(from: 0);
        } else {
          if (_isFirstStop && _stopCtrl.value == 0.0) {
            _rotateCtrl.duration = _stopCtrl.duration;
            _speed = _speed * _stopDuration / _rotateDuration;
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
    _speed = _stopDuration / _rotateDuration;
    _rotateCtrl.duration = const Duration(milliseconds: _rotateDuration);
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
}

class WheelDebug {
  static void log(String? message) {
    if (kDebugMode) {
      print('LuckyWheel ==> $message');
    }
  }
}
