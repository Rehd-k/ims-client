import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../app_router.gr.dart';

@RoutePage()
class ErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final Map? details;
  const ErrorScreen({super.key, this.onRetry, this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                  'assets/lottie/error.json', // Add an animated error illustration
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  repeat: false),
              const SizedBox(height: 20),
              Text(
                "Oops! Something went wrong",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SelectableText(
                details == null
                    ? "We couldn't process your request. Please go back your or try again."
                    : details!['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Go Back",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  onRetry != null
                      ? ElevatedButton(
                          onPressed: onRetry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Try Again",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () =>
                              context.replaceRoute(DashboardRoute()),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Go Home",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
