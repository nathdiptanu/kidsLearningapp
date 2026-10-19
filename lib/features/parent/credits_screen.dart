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
            'Teaching images are bundled locally. New picture-word illustrations were generated for SproutLab and checked for recognizable subjects. Monument photographs retain their authors and licences below. Children do not open websites.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: SproutSpace.sm),
          Text(
            'The zoomable map is the Survey of India Political Map of India, English 13th edition, 2026. It is rendered uniformly from the official PDF; borders are not redrawn. Source: Survey of India, Government of India. Hindi and India use installed offline device voices as an interim option approved by the owner. Legacy unreviewed tracing and polygon-map lessons remain excluded from release.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: SproutSpace.lg),
          const SelectableText('Interactive state outlines: Survey of India, 2023. Public-domain source with permission ticket 2023040810000569. Original geographic lines retained; uniform scaling and pastel fills added. https://commons.wikimedia.org/wiki/File:States_of_India_(Survey_of_India).svg\nQutb Minar photo: Fuzail Ahmad, CC BY-SA 4.0; Wikimedia 960-pixel thumbnail. https://commons.wikimedia.org/wiki/File:Qutub_Minar_Vertical2.jpg\nRed Fort photo: Michael Clarke, CC BY-SA 2.0, unchanged. https://commons.wikimedia.org/wiki/File:Red_fort_new_delhi_with_indian_flag.jpg\nLicence: https://creativecommons.org/licenses/by-sa/2.0/\nAdditional fact references: UNESCO 233 and 231. Capital conventions are explained for seasonal and shared capitals.'),
          const SizedBox(height: SproutSpace.lg),
          const SelectableText(
            'Map source: https://surveyofindia.gov.in/pages/political-map-of-india\nDigital map guidance: https://onlinemaps.surveyofindia.gov.in/GeospatialGuidelines.aspx\nTaj Mahal photo: Divya Shikhar, CC BY-SA 4.0\nhttps://commons.wikimedia.org/wiki/File:Taj_Mahal,_front_view.jpg\nSanchi photo: Kaushlendrapathe, CC BY-SA 4.0\nhttps://commons.wikimedia.org/wiki/File:Sanchi_Main_Stupa.jpg\nKonark photo: Mayank Choudhary, CC BY-SA 3.0\nhttps://commons.wikimedia.org/wiki/File:Sun_Temple_at_Konark.jpg\nShore Temple photo: Rainer Halama, CC BY-SA 4.0\nhttps://commons.wikimedia.org/wiki/File:Mahabalipuram-Shore_Temple-WUS01991.jpg\nLicences: https://creativecommons.org/licenses/by-sa/4.0/ and https://creativecommons.org/licenses/by-sa/3.0/\nPhotographs are bundled unchanged. Fact references: UNESCO records 252, 524, 246 and 249; neighbour names follow Ministry of Home Affairs. Music: owner-supplied sproutlab-gentle-loop.wav.',
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
