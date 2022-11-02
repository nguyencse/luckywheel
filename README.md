Easier to create your Lucky Wheel!

## Getting Started  
  
To use this plugin, add `luckywheel` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). 

See the example to get started quickly. To generate the platform folders run:

```dart
flutter create .
```
in the example folder.

To begin you need to instantiate a `LuckyWheelController` variable and pass in a `controller` argument of `LuckyWheel` widget.
```dart
LuckyWheelController _wheelController = LuckyWheelController(
  vsync: this,
  totalParts: 8,
  onRotationEnd: (idx) {
    _result.value = idx;
  },
);
```

After that, you can easily use the LuckyWheel Widget with the code below.

```dart
LuckyWheel(
  controller: _wheelController,
  onResult: (result) {
    _result.value = result;
  },
  child: const SpinningWidget(width: 300, height: 300, totalParts: 8),
  // child: Image.asset('images/wheel.png', width: 300, height: 300),
),
```
<img src="https://github.com/nguyencse/luckywheel/raw/master/screenshots/1.png" align = "left" width="300">
<img src="https://github.com/nguyencse/luckywheel/raw/master/screenshots/2.png" align = "left" width="300">

### Enjoy the Lucky Wheel.
