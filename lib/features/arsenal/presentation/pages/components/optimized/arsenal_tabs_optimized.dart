import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_core_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_family_providers.dart';

part 'arsenal_tabs_optimized.g.dart';

/// Optimized Arsenal tabs with performance improvements
class ArsenalTabsOptimized extends ConsumerStatefulWidget {
  final List<Color> bagColors;
  final Function(int bagNumber) onBagSelected;
  final int initialBagNumber;
  
  const ArsenalTabsOptimized({
    super.key,
    required this.bagColors,
    required this.onBagSelected,
    this.initialBagNumber = 1,
  });

  @override
  ConsumerState<ArsenalTabsOptimized> createState() => _ArsenalTabsOptimizedState();
}

class _ArsenalTabsOptimizedState extends ConsumerState<ArsenalTabsOptimized>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late TabController _tabController;
  
  @override
  bool get wantKeepAlive => true; // Keep tab state alive

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.bagColors.length,
      vsync: this,
      initialIndex: widget.initialBagNumber - 1,
    );
    
    _tabController.addListener(_onTabChanged);
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }
  
  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final bagNumber = _tabController.index + 1;
      widget.onBagSelected(bagNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    final coreState = ref.watch(arsenalCoreStateProviderProvider);
    final availableBags = ref.watch(_availableBagsProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorWeight: 3,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        tabs: List.generate(widget.bagColors.length, (index) {
          final bagNumber = index + 1;
          final isAvailable = availableBags.contains(bagNumber);
          
          return _ArsenalTab(
            bagNumber: bagNumber,
            color: widget.bagColors[index],
            isAvailable: isAvailable,
          );
        }),
      ),
    );
  }
}

/// Individual Arsenal tab with optimized rendering
class _ArsenalTab extends ConsumerWidget {
  final int bagNumber;
  final Color color;
  final bool isAvailable;
  
  const _ArsenalTab({
    required this.bagNumber,
    required this.color,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use family provider to watch count for this specific bag
    final instanceCount = ref.watch(arsenalInstancesCountByBagProvider(bagNumber));
    final hasInstances = ref.watch(bagHasInstancesProvider(bagNumber));
    
    return Tab(
      child: _TabContent(
        bagNumber: bagNumber,
        color: color,
        instanceCount: instanceCount,
        hasInstances: hasInstances,
        isAvailable: isAvailable,
      ),
    );
  }
}

/// Tab content with const constructor for better performance
class _TabContent extends StatelessWidget {
  final int bagNumber;
  final Color color;
  final int instanceCount;
  final bool hasInstances;
  final bool isAvailable;
  
  const _TabContent({
    required this.bagNumber,
    required this.color,
    required this.instanceCount,
    required this.hasInstances,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bag indicator with color
          _BagIndicator(
            bagNumber: bagNumber,
            color: color,
            isAvailable: isAvailable,
            hasInstances: hasInstances,
          ),
          
          const SizedBox(height: 4),
          
          // Bag label
          Text(
            _getBagLabel(bagNumber),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Instance count
          if (hasInstances) ...[
            const SizedBox(height: 2),
            _InstanceCountIndicator(count: instanceCount),
          ],
        ],
      ),
    );
  }
  
  String _getBagLabel(int bagNumber) {
    return bagNumber == 1 ? 'Arsenal' : 'Bag $bagNumber';
  }
}

/// Bag indicator circle with optimized rendering
class _BagIndicator extends StatelessWidget {
  final int bagNumber;
  final Color color;
  final bool isAvailable;
  final bool hasInstances;
  
  const _BagIndicator({
    required this.bagNumber,
    required this.color,
    required this.isAvailable,
    required this.hasInstances,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAvailable ? color : Colors.grey[300],
        border: hasInstances
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: hasInstances
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          bagNumber == 1 ? 'A' : '$bagNumber',
          style: TextStyle(
            color: isAvailable ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Instance count indicator with const constructor
class _InstanceCountIndicator extends StatelessWidget {
  final int count;
  
  const _InstanceCountIndicator({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

/// Provider for available bags (bags that have instances)
@riverpod
List<int> _availableBags(_AvailableBagsRef ref) {
  final coreState = ref.watch(arsenalCoreStateProviderProvider);
  
  if (coreState.allInstances.isEmpty) {
    return [1]; // Always include main arsenal
  }
  
  final bagNumbers = <int>{1}; // Always include main arsenal
  
  for (final instance in coreState.allInstances) {
    bagNumbers.addAll(instance.activeBagNumbers);
  }
  
  return bagNumbers.toList()..sort();
}

/// Optimized Arsenal tab view with keep alive functionality
class ArsenalTabViewOptimized extends ConsumerStatefulWidget {
  final List<Widget> children;
  final TabController? controller;
  
  const ArsenalTabViewOptimized({
    super.key,
    required this.children,
    this.controller,
  });

  @override
  ConsumerState<ArsenalTabViewOptimized> createState() => 
      _ArsenalTabViewOptimizedState();
}

class _ArsenalTabViewOptimizedState extends ConsumerState<ArsenalTabViewOptimized>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // Keep all tab views alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return TabBarView(
      controller: widget.controller,
      children: widget.children.map((child) => _KeepAliveWrapper(child: child)).toList(),
    );
  }
}

/// Wrapper to keep individual tab views alive
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  
  const _KeepAliveWrapper({
    required this.child,
  });

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return widget.child;
  }
}