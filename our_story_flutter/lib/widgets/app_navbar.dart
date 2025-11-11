import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/primary_button.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;

        final navLinks = [
          _NavLink(
            label: 'Home',
            onTap: () => context.go('/'),
          ),
          _NavLink(
            label: 'Story',
            onTap: () {},
          ),
          _NavLink(
            label: 'Timeline',
            onTap: () {},
          ),
          _NavLink(
            label: 'Gallery',
            onTap: () {},
          ),
          _NavLink(
            label: 'Notes',
            onTap: () {},
          ),
        ];

        if (isCompact) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Story',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    ...navLinks,
                    PrimaryButton(
                      label: 'Log in',
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          child: Row(
            children: [
              Text(
                'Our Story',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              ..._withSpacing(navLinks),
              const SizedBox(width: 32),
              PrimaryButton(
                label: 'Log in',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color.withOpacity(0.7),
        ),
      ),
    );
  }
}

Iterable<Widget> _withSpacing(List<Widget> children) sync* {
  for (var i = 0; i < children.length; i++) {
    yield children[i];
    if (i != children.length - 1) {
      yield const SizedBox(width: 24);
    }
  }
}

