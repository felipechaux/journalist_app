import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shineAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.addListener(() {
      if (_controller.value > 0.4 && _controller.value < 0.45) {
        HapticFeedback.heavyImpact();
      }
      if (_controller.value > 0.6 && _controller.value < 0.65) {
        HapticFeedback.lightImpact();
      }
      if (_controller.value > 0.8 && _controller.value < 0.85) {
        HapticFeedback.mediumImpact();
      }
    });

    _controller.forward().then((_) {
      // Navigate to Home
      Navigator.pushReplacementNamed(context, '/DailyNews');
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
      backgroundColor: const Color(0xFF0D1B2A), // Dark blue from prompt
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment(-1.0 + _shineAnimation.value, -1.0),
                      end: Alignment(1.0 + _shineAnimation.value, 1.0),
                    ).createShader(bounds);
                  },
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
