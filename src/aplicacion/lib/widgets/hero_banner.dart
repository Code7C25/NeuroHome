import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'glow_circle.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String locale;

  const HeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -30,
                child: GlowCircle(
                  size: 160,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Positioned(
                left: -50,
                bottom: -50,
                child: GlowCircle(
                  size: 180,
                  color: theme.colorScheme.primary.withOpacity(0.35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.85),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}