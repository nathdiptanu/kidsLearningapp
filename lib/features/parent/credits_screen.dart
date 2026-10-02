import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../core/design_system/widgets/sprout_card.dart';
import '../../core/design_system/widgets/status_chip.dart';
import '../../domain/heritage/heritage_models.dart';
import '../../domain/heritage/heritage_pack.dart';
import '../../domain/models/content_pack.dart';
import 'parent_hold_gate.dart';

/// Sources and credits for grown-ups. URLs stay on this page as text.
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParentHoldGate(
      revokeOnDispose: false,
      title: 'Sources and credits',
      child: CreditsBody(),
    );
  }
}

class CreditsBody extends StatelessWidget {
  const CreditsBody({this.records, super.key});

  final List<CreditRecord>? records;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = records ?? parentVisibleCredits();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        SproutSpace.page,
        SproutSpace.sm,
        SproutSpace.page,
        SproutSpace.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Sources and credits', style: text.headlineMedium),
          const SizedBox(height: SproutSpace.sm),
          Text(
            'These notes are for grown-ups. Child screens use original drawings and short original summaries. They do not open websites or hotlink other people’s pictures. Google image results were used only as discovery, never as files.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: SproutSpace.sm),
          Text(
            'Hindi, map and heritage samples on this device are development records until a reviewer marks them approved. Optional downloadable packs are not part of this version.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: SproutSpace.lg),
          for (final record in items) ...[
            _CreditCard(record: record),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({required this.record});

  final CreditRecord record;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SproutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.title, style: text.titleMedium),
          const SizedBox(height: SproutSpace.xs),
          Text(record.detail, style: text.bodyMedium),
          if (record.creator != null) Text('Creator: ${record.creator}'),
          if (record.license != null) Text('Licence: ${record.license}'),
          if (record.attribution != null) Text(record.attribution!),
          if (record.modifications != null)
            Text('Changes: ${record.modifications}'),
          if (record.localFile != null) Text('File: ${record.localFile}'),
          if (record.sourceUrl != null) ...[
            const SizedBox(height: SproutSpace.xs),
            Text(record.sourceUrl!, style: text.bodySmall),
          ],
          const SizedBox(height: SproutSpace.sm),
          StatusChip(
            label: record.reviewStatus == ReviewStatus.approved
                ? 'Reviewed'
                : 'Awaiting review',
            tone: StatusTone.info,
          ),
        ],
      ),
    );
  }
}
