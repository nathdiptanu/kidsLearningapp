import 'package:flutter/material.dart';

import '../learning_area.dart';
import '../sprout_tokens.dart';
import 'fox_mascot.dart';

/// Pushed page with a Back button, a title and a centred body that stays
/// readable on tablets.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            height: containsDevanagari(title)
                ? SproutType.devanagariHeight
                : null,
            fontFamilyFallback: SproutType.fallback,
          ),
        ),
        actions: actions,
      ),
      body: SafeArea(top: false, child: PageWidth(child: body)),
    );
  }
}

class PageWidth extends StatelessWidget {
  const PageWidth({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: SproutSize.pageMaxWidth),
        child: child,
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.title, this.detail, super.key});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.only(
          top: SproutSpace.lg,
          bottom: SproutSpace.sm + 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (detail != null) ...[
              const SizedBox(height: 2),
              Text(detail!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

/// Calm empty or error message with the fox.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    this.action,
    this.mascotSize = 120,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;
  final double mascotSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SproutSpace.lg),
      child: Column(
        children: [
          FoxMascot(size: mascotSize),
          const SizedBox(height: SproutSpace.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SproutSpace.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: SproutSpace.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
