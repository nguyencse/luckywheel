import 'package:flutter/material.dart';
import 'package:luckywheel/luckywheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuckyWheel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ValueNotifier<int> _result = ValueNotifier<int>(0);

  late LuckyWheelController _wheelController;

  @override
  void initState() {
    super.initState();
    _wheelController = LuckyWheelController(
      vsync: this,
      totalParts: 8,
      onRotationEnd: (idx) {
        _result.value = idx;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _result,
                  builder: (context, child) => Text(
                    '${_result.value}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  children: [
                    LuckyWheel(
                      controller: _wheelController,
                      onResult: (result) {
                        _result.value = result;
                      },
                      child: const SpinningWidget(
                          width: 300, height: 300, totalParts: 8),
                      // child: Image.asset('images/wheel.png', width: 300, height: 300),
                    ),
                    Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          _wheelController.reset();
                          _wheelController.start();
                        },
                        child: Image.asset('assets/images/btn_rotate.png',
                            width: 64, height: 64),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    _wheelController.reset();
                    _wheelController.start();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    _wheelController.stop();
                    // _wheelController.stop(atIndex: 5);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Stop',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
