import 'package:flight/core/constants/app_constants.dart';
import 'package:flight/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'flight_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(AppConstants.airplaneVideo)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0x00000000), Color(0xCC000000)],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Fly',
                        style: TextStyle(
                          color: Color(0xFF1565A8),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'WT',
                        style: TextStyle(
                          color: Color(0xFFF7941D),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'DISCOVER THE\nWORLD WITH THE\nBEST FLIGHTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GeneralComponent.appButton(
                    label: 'CONTINUE',
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const FlightScreen()),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}