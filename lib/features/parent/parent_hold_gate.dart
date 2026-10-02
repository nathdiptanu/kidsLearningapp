import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_theme.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/app_page_scaffold.dart';
import '../../core/design_system/widgets/fox_mascot.dart';
import '../../core/design_system/widgets/sprout_card.dart';

class ParentHoldGate extends ConsumerStatefulWidget {
  const ParentHoldGate({
    required this.child,
    this.revokeOnDispose = true,
    this.title = 'Grown-up area',
    super.key,
  });

  final Widget child;
  final bool revokeOnDispose;
  final String title;

  @override
  ConsumerState<ParentHoldGate> createState() => _ParentHoldGateState();
}

class _ParentHoldGateState extends ConsumerState<ParentHoldGate>
    with WidgetsBindingObserver {
  double _hold = 0;
  String? _hint;
  Timer? _timer;
  ParentGateSession? _gate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gate = ref.read(parentGateProvider.notifier);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _timer?.cancel();
      _gate?.revoke();
      if (mounted) {
        setState(() {
          _hold = 0;
          _hint = null;
        });
      }
    } else if (state == AppLifecycleState.resumed && mounted) {
      setState(() {
        _hold = 0;
        _hint = null;
      });
    }
  }

  void _startHold() {
    _timer?.cancel();
    _hint = null;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        return;
      }
      setState(() => _hold += 0.1 / 3);
      if (_hold >= 1) {
        timer.cancel();
        _gate?.grant();
      }
    });
  }

  void _endHold() {
    _timer?.cancel();
    if (mounted && !ref.read(parentGateProvider) && _hold > 0 && _hold < 1) {
      setState(() {
        _hold = 0;
        _hint = 'Hold a little longer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final open = ref.watch(parentGateProvider);
    return Theme(
      data: SproutTheme.parent(),
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop && widget.revokeOnDispose) {
            final gate = _gate;
            Future<void>(() {
              gate?.revoke();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(open ? widget.title : 'Grown-up area')),
          body: SafeArea(
            top: false,
            child: PageWidth(
              child: open
                  ? widget.child
                  : _HoldGate(
                      progress: _hold,
                      hint: _hint,
                      onDown: _startHold,
                      onUp: _endHold,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoldGate extends StatelessWidget {
  const _HoldGate({
    required this.progress,
    required this.hint,
    required this.onDown,
    required this.onUp,
  });

  final double progress;
  final String? hint;
  final VoidCallback onDown;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(SproutSpace.page),
      children: [
        SproutCard(
          child: Column(
            children: [
              const FoxMascot(size: 110),
              const SizedBox(height: SproutSpace.sm),
              Text(
                'Parents: press and hold for 3 seconds.',
                textAlign: TextAlign.center,
                style: text.headlineSmall,
              ),
              const SizedBox(height: SproutSpace.sm),
              Semantics(
                liveRegion: true,
                child: Text(
                  hint ?? 'This opens learning notes, settings and Premium.',
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: hint == null ? null : SproutColors.retry,
                    fontWeight: hint == null ? null : FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: SproutSpace.lg),
              Semantics(
                button: true,
                label: 'Parents: press and hold for 3 seconds.',
                value: '${(progress.clamp(0, 1) * 100).round()} percent',
                excludeSemantics: true,
                child: Listener(
                  onPointerDown: (_) => onDown(),
                  onPointerUp: (_) => onUp(),
                  onPointerCancel: (_) => onUp(),
                  child: SizedBox.square(
                    dimension: 148,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progress.clamp(0, 1),
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Container(
                          width: 112,
                          height: 112,
                          decoration: const BoxDecoration(
                            color: SproutColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                color: SproutColors.surface,
                                size: 32,
                              ),
                              Text(
                                'Hold',
                                style: TextStyle(
                                  fontFamily: SproutType.family,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: SproutColors.surface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SproutSpace.md),
            ],
          ),
        ),
      ],
    );
  }
}
