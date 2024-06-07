import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:particles_flutter/particles_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Falz the bahd guy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  Duration _duration = const Duration();
  final DateTime targetDate = DateTime(2024, 6, 7, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = targetDate.difference(now);

      setState(() {
        _duration = difference;
      });

      if (_duration.isNegative) {
        _timer.cancel();
      }
    });
  }

  String _formatDay(Duration duration) {
    int days = duration.inDays;
    return '$days ${(days < 2 ? 'day' : 'days')} ';
  }

  String _timeOnly(Duration duration) {
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${(minutes < 10 ? '0$minutes' : minutes)}:${(seconds < 10 ? '0$seconds' : seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget imageContainer({double? width, double? height}) {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.black26,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(size.height / 100),
        margin: EdgeInsets.all(size.height / 50),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            width: width,
            height: height,
            'assets/falz.jpg',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    Row timerText({double fontSize = 60}) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDay(_duration),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "SFPI",
              fontSize: fontSize,
              color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w900,
            ),
          ),
          Flexible(
            child: Text(
              _timeOnly(_duration),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SFPI",
                fontSize: fontSize / 3,
                color: Colors.black.withOpacity(.7),
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    }

    CircularParticle bgAnimation() {
      return CircularParticle(
        width: size.width,
        height: size.height,
        particleColor: Colors.white.withOpacity(.6),
        numberOfParticles: 50,
        speedOfParticles: 1,
        maxParticleSize: 7,
        awayRadius: 0,
        onTapAnimation: false,
        isRandSize: true,
        isRandomColor: false,
        connectDots: false,
        enableHover: false,
      );
    }

    Widget myBlurs() {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.transparent,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 139, 139),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 730) {
            // Desktop view
            return Stack(
              children: [
                bgAnimation(),
                myBlurs(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: timerText(fontSize: 100),
                      ),
                      Flexible(
                        flex: 1,
                        child: imageContainer(
                          height: size.height / 1.3,
                          width: size.height / 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Mobile view
            return Stack(
              children: [
                bgAnimation(),
                myBlurs(),
                SizedBox(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display countdown timer
                      timerText(),
                      imageContainer(width: size.width / 1.5),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
