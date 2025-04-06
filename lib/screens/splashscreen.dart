// splash_page.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invease/app_router.gr.dart';

// import '../app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoOffset;

  late AnimationController _shelfController;
  late Animation<double> _shelfOpacity;
  late Animation<Offset> _shelfOffset;

  late AnimationController _subTextController;
  late Animation<double> _subTextOpacity;

  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (!mounted) return;

      setState(() {
        _opacity = 0.0;
      });

      // Navigate after the fade-out completes
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        context.replaceRoute(LoginRoute());
      });
    });

    // Logo slide animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _logoOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.2),
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    // Shelf Sense fade & slide
    _shelfController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shelfOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shelfController, curve: Curves.easeIn),
    );
    _shelfOffset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _shelfController, curve: Curves.easeOut));

    // Subtext fade in
    _subTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _subTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _subTextController, curve: Curves.easeIn),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 2000)); // 1) logo shows
    await _logoController.forward(); // 2) logo slides up
    await _shelfController.forward(); // 3) Shelf Sense appears
    await _subTextController.forward(); // 4) subtext fades in
  }

  @override
  void dispose() {
    _logoController.dispose();
    _shelfController.dispose();
    _subTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _opacity,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlideTransition(
                    position: _logoOffset,
                    child: SvgPicture.asset(
                      'assets/vectors/logo.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  FadeTransition(
                    opacity: _shelfOpacity,
                    child: SlideTransition(
                      position: _shelfOffset,
                      child: Text(
                        'Shelf Sense',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _subTextOpacity,
                    child: const Text(
                      'A smart inventory management system',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'From Vessel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
