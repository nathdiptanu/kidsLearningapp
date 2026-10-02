import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../explore/explore_screen.dart';
import '../home/home_screen.dart';
import '../rewards/rewards_screen.dart';

class ChildShell extends StatefulWidget {
  const ChildShell({super.key});

  @override
  State<ChildShell> createState() => _ChildShellState();
}

class _ChildShellState extends State<ChildShell> {
  int _index = 0;
  final List<bool> _built = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: SproutSize.pageMaxWidth),
          child: IndexedStack(
            index: _index,
            children: [
              const HomeScreen(),
              _built[1] ? const ExploreScreen() : const SizedBox.shrink(),
              _built[2] ? const RewardsScreen() : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ChildBottomNavigation(
        index: _index,
        onSelected: (index) {
          setState(() {
            _built[index] = true;
            _index = index;
          });
        },
      ),
    );
  }
}

class ChildBottomNavigation extends StatelessWidget {
  const ChildBottomNavigation({
    required this.index,
    required this.onSelected,
    super.key,
  });

  final int index;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SproutColors.surface,
        border: Border(top: BorderSide(color: SproutColors.cardEdge)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F172033),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: index,
        height: (76 * scale).clamp(76, 116),
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }
}
