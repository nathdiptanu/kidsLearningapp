import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap_state.dart';
import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/brand_header.dart';
import '../../core/errors/app_failure.dart';
import '../onboarding/onboarding_screen.dart';
import '../shell/child_shell.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bootstrapStateProvider);
    return switch (state) {
      BootstrapReady() => const _SessionGate(),
      BootstrapFailed(:final failure) => RecoverableErrorScreen(
        failure: failure,
      ),
    };
  }
}

class _SessionGate extends ConsumerWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return session.when(
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => RecoverableErrorScreen(
        failure: error is AppFailure ? error : const DatabaseFailure(),
      ),
      data: (value) => value.readyForPlay
          ? const ChildShell()
          : OnboardingScreen(initial: value.settings),
    );
  }
}

class RecoverableErrorScreen extends StatelessWidget {
  const RecoverableErrorScreen({required this.failure, super.key});

  final Object failure;

  @override
  Widget build(BuildContext context) {
    final Object problem = failure;
    final message = problem is AppFailure
        ? problem.userMessage
        : 'Something went wrong. Please close the app and open it again.';
    return Scaffold(
      body: SafeArea(
        child: PageWidth(
          child: ListView(
            padding: const EdgeInsets.all(SproutSpace.page),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: SproutWordmark(),
              ),
              const SizedBox(height: SproutSpace.lg),
              EmptyState(
                title: 'SproutLab needs a restart',
                message: message,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
