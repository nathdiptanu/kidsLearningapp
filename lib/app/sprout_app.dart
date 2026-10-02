import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/sprout_theme.dart';
import '../core/errors/local_log.dart';
import 'app_identity.dart';
import 'bootstrap_state.dart';
import 'router.dart';
import 'session_providers.dart';

class SproutApp extends ConsumerStatefulWidget {
  const SproutApp({super.key});

  @override
  ConsumerState<SproutApp> createState() => _SproutAppState();
}

class _SproutAppState extends ConsumerState<SproutApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reconcile();
      _syncReminder();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final audio = ref.read(audioControllerProvider);
    if (state == AppLifecycleState.resumed) {
      audio.resumeForLifecycle();
      _reconcile();
      _syncReminder();
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      audio.pauseForLifecycle();
    }
  }

  Future<void> _syncReminder() async {
    if (!mounted || ref.read(bootstrapStateProvider) is! BootstrapReady) {
      return;
    }
    final session = ref.read(sessionProvider).value;
    if (session == null) {
      return;
    }
    final settings = session.settings;
    final kept = await ref
        .read(reminderPortProvider)
        .sync(
          enabled: settings.remindersEnabled,
          minutesFromMidnight: settings.reminderMinutes,
        );
    if (!kept && settings.remindersEnabled && mounted) {
      await ref
          .read(sessionProvider.notifier)
          .saveSettings(settings.copyWith(remindersEnabled: false));
    }
  }

  Future<void> _reconcile() async {
    if (!mounted || ref.read(bootstrapStateProvider) is! BootstrapReady) {
      return;
    }
    try {
      await ref.read(billingGatewayProvider).refresh();
      ref.invalidate(entitlementProvider);
    } catch (_) {
      LocalLog.debug('entitlement refresh failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduced =
        ref.watch(sessionProvider).value?.settings.reducedMotion ?? false;
    return MaterialApp(
      title: AppIdentity.visibleName,
      theme: SproutTheme.child(),
      onGenerateRoute: SproutRouter.onGenerateRoute,
      builder: (context, child) {
        final page = child ?? const SizedBox.shrink();
        if (!reduced) {
          return page;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: page,
        );
      },
    );
  }
}
