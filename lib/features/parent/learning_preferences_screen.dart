import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/primary_kid_button.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../domain/regional/learning_preferences.dart';
import '../../domain/settings/local_settings.dart';
import 'parent_hold_gate.dart';

class LearningPreferencesScreen extends StatelessWidget {
  const LearningPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParentHoldGate(
      revokeOnDispose: false,
      title: 'Learning preferences',
      child: _PreferencesForm(),
    );
  }
}

class _PreferencesForm extends ConsumerStatefulWidget {
  const _PreferencesForm();

  @override
  ConsumerState<_PreferencesForm> createState() => _PreferencesFormState();
}

class _PreferencesFormState extends ConsumerState<_PreferencesForm> {
  LearningRegion? _region;
  late InterfaceLanguage _interface;
  late TeachingLanguage _teaching;
  late bool _hindi;
  late bool _discoverIndia;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final settings =
        ref.read(sessionProvider).value?.settings ?? LocalSettings.defaults;
    _region = settings.learningRegion;
    _interface = settings.interfaceLanguage;
    _teaching = settings.teachingLanguage;
    _hindi = settings.hindiEnabled;
    _discoverIndia = settings.discoverIndiaEnabled;
  }

  Future<void> _save() async {
    final settings = ref.read(sessionProvider).value?.settings;
    if (_saving || settings == null) {
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(sessionProvider.notifier)
        .saveSettings(
          settings.copyWith(
            learningRegion: _region,
            interfaceLanguage: _interface,
            teachingLanguage: _teaching,
            hindiEnabled: _hindi,
            discoverIndiaEnabled: _discoverIndia,
          ),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final india = _region == LearningRegion.india;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SproutSpace.page,
        SproutSpace.sm,
        SproutSpace.page,
        SproutSpace.xl,
      ),
      children: [
        PreferenceGroup(
          title: 'Learning region',
          children: [
            Text(
              'Choose which learning activities to show. This is not worked out from location, and changing it keeps all progress.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            RegionChoices(
              selected: _region,
              onSelected: (region) => setState(() => _region = region),
            ),
          ],
        ),
        PreferenceGroup(
          title: 'India activities',
          children: [
            Text(
              india ? 'Shown in Explore when switched on.' : 'Only offered when the learning region is India. Saved choices are kept.',
              style: text.bodyMedium,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hindi'),
              subtitle: const Text('Letters, sounds and words'),
              value: _hindi,
              onChanged: india
                  ? (value) => setState(() => _hindi = value)
                  : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Discover India'),
              subtitle: const Text('Places, maps and heritage'),
              value: _discoverIndia,
              onChanged: india
                  ? (value) => setState(() => _discoverIndia = value)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              'Hindi and Discover India samples on this device do not use the 5 free activities in Maths, Words or the other games. Premium is the same grown-up purchase as today. Turning a switch off hides the activities and keeps saved progress.',
              style: text.bodySmall,
            ),
          ],
        ),
        PreferenceGroup(
          title: 'Languages',
          children: [
            Text('Buttons and instructions', style: text.titleSmall),
            const SizedBox(height: SproutSpace.sm),
            for (final language in InterfaceLanguage.values)
              _LanguageOption(
                label: language.label,
                selected: _interface == language,
                enabled: language.available,
                note: language.available ? null : 'Not available yet',
                onTap: () => setState(() => _interface = language),
              ),
            const SizedBox(height: SproutSpace.md),
            Text('Teaching language in lessons', style: text.titleSmall),
            const SizedBox(height: SproutSpace.xs),
            Text(
              'Separate from the region. English activities stay in English.',
              style: text.bodySmall,
            ),
            const SizedBox(height: SproutSpace.sm),
            for (final language in TeachingLanguage.values)
              _LanguageOption(
                label: language.label,
                selected: _teaching == language,
                enabled: true,
                onTap: () => setState(() => _teaching = language),
              ),
          ],
        ),
        const SizedBox(height: SproutSpace.lg),
        PrimaryKidButton(label: 'Save', onPressed: _saving ? null : _save),
      ],
    );
  }
}

/// Region radio rows shared by onboarding and settings.
class RegionChoices extends StatelessWidget {
  const RegionChoices({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final LearningRegion? selected;
  final ValueChanged<LearningRegion> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final region in LearningRegion.values) ...[
          ChoiceRow(
            label: region.label,
            detail: region == LearningRegion.india
                ? 'Adds Hindi and Discover India'
                : 'Global activities in English',
            selected: selected == region,
            onTap: () => onSelected(region),
          ),
          const SizedBox(height: SproutSpace.sm),
        ],
      ],
    );
  }
}

/// Large single-choice row with a check icon. Parent target size.
class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.detail,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String? detail;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: enabled,
      label: [label, ?detail].join('. '),
      onTap: enabled ? onTap : null,
      excludeSemantics: true,
      child: Material(
        color: selected ? SproutColors.primarySoft : SproutColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(SproutRadius.tile),
          ),
          side: BorderSide(
            color: selected ? SproutColors.primary : SproutColors.line,
            width: selected ? 3 : 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SproutSize.parentTarget + 8,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SproutSpace.md,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: enabled
                        ? (selected
                              ? SproutColors.primary
                              : SproutColors.inkMuted)
                        : SproutColors.disabledInk,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: text.bodyLarge?.copyWith(
                            height: SproutType.devanagariHeight,
                          ),
                        ),
                        if (detail != null)
                          Text(detail!, style: text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
    this.note,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final String? note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SproutSpace.sm),
      child: ChoiceRow(
        label: label,
        detail: note,
        selected: selected,
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}

/// Titled settings card.
class PreferenceGroup extends StatelessWidget {
  const PreferenceGroup({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: SproutSpace.lg),
      child: SproutCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
