import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_family_providers.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_state_mixin.dart';

/// Optimized Arsenal ball item widget with performance improvements
class ArsenalBallItemOptimized extends ConsumerWidget with ArsenalStateMixin {
  final int instanceId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showActions;
  
  const ArsenalBallItemOptimized({
    super.key,
    required this.instanceId,
    this.onTap,
    this.onLongPress,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use family provider to watch only this specific instance
    final instance = ref.watch(arsenalInstanceByIdProvider(instanceId));
    final isSelected = ref.watch(isInstanceSelectedProvider(instanceId));
    
    // If instance is null, return empty container
    if (instance == null) {
      return const SizedBox.shrink();
    }
    
    return _ArsenalBallItemContent(
      instance: instance,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      showActions: showActions,
    );
  }
}

/// Internal content widget using const constructor for better performance
class _ArsenalBallItemContent extends StatelessWidget {
  final UserArsenalInstance instance;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showActions;
  
  const _ArsenalBallItemContent({
    required this.instance,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected 
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ball image with optimized loading
              _BallImageSection(
                imageUrl: instance.imageUrl,
                ballName: instance.displayName,
              ),
              
              // Ball information
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ball name - using const Text where possible
                    Text(
                      instance.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Brand name
                    Text(
                      instance.brandName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Statistics row
                    _BallStatsRow(
                      gamesUsed: instance.gamesUsed,
                      weight: instance.weight,
                    ),
                    
                    // Active bags indicator
                    if (instance.activeBagNumbers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _ActiveBagsIndicator(
                        bagNumbers: instance.activeBagNumbers,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Optimized ball image section with cached network image
class _BallImageSection extends StatelessWidget {
  final String? imageUrl;
  final String ballName;
  
  const _BallImageSection({
    required this.imageUrl,
    required this.ballName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _FallbackBallImage(ballName: ballName);
                },
              )
            : _FallbackBallImage(ballName: ballName),
      ),
    );
  }
}

/// Fallback image widget with const constructor
class _FallbackBallImage extends StatelessWidget {
  final String ballName;
  
  const _FallbackBallImage({
    required this.ballName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_bowling,
            size: 32,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            ballName.length > 10 ? '${ballName.substring(0, 10)}...' : ballName,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Ball statistics row with const widgets
class _BallStatsRow extends StatelessWidget {
  final int gamesUsed;
  final double weight;
  
  const _BallStatsRow({
    required this.gamesUsed,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Games used
        const Icon(Icons.sports_esports, size: 12, color: Colors.blue),
        const SizedBox(width: 4),
        Text(
          '$gamesUsed',
          style: const TextStyle(fontSize: 10, color: Colors.blue),
        ),
        
        const SizedBox(width: 12),
        
        // Weight
        const Icon(Icons.fitness_center, size: 12, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          '${weight.toStringAsFixed(1)} lbs',
          style: const TextStyle(fontSize: 10, color: Colors.orange),
        ),
      ],
    );
  }
}

/// Active bags indicator with efficient rendering
class _ActiveBagsIndicator extends StatelessWidget {
  final List<int> bagNumbers;
  
  const _ActiveBagsIndicator({
    required this.bagNumbers,
  });

  @override
  Widget build(BuildContext context) {
    // Limit display to first 3 bags for performance
    final displayBags = bagNumbers.take(3).toList();
    final hasMore = bagNumbers.length > 3;
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displayBags.map((bagNumber) => _BagChip(bagNumber: bagNumber)),
        if (hasMore)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${bagNumbers.length - 3}',
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

/// Individual bag chip with const constructor
class _BagChip extends StatelessWidget {
  final int bagNumber;
  
  const _BagChip({
    required this.bagNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getBagColor(bagNumber),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$bagNumber',
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Color _getBagColor(int bagNumber) {
    // Simple color mapping for bag numbers
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[(bagNumber - 1) % colors.length];
  }
}

/// Optimized Arsenal grid view with keep alive functionality
class ArsenalGridViewOptimized extends ConsumerStatefulWidget {
  final int bagNumber;
  final Function(int instanceId)? onBallTap;
  final Function(int instanceId)? onBallLongPress;
  
  const ArsenalGridViewOptimized({
    super.key,
    required this.bagNumber,
    this.onBallTap,
    this.onBallLongPress,
  });

  @override
  ConsumerState<ArsenalGridViewOptimized> createState() => 
      _ArsenalGridViewOptimizedState();
}

class _ArsenalGridViewOptimizedState extends ConsumerState<ArsenalGridViewOptimized>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // Keep state alive when switching tabs

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Use family provider for this specific bag
    final instances = ref.watch(arsenalInstancesByBagProvider(widget.bagNumber));
    
    if (instances.isEmpty) {
      return const _EmptyArsenalView();
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: instances.length,
      itemBuilder: (context, index) {
        final instance = instances[index];
        return ArsenalBallItemOptimized(
          instanceId: instance.id,
          onTap: widget.onBallTap != null 
              ? () => widget.onBallTap!(instance.id)
              : null,
          onLongPress: widget.onBallLongPress != null 
              ? () => widget.onBallLongPress!(instance.id)
              : null,
        );
      },
    );
  }
}

/// Empty arsenal view with const constructor
class _EmptyArsenalView extends StatelessWidget {
  const _EmptyArsenalView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_bowling_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No balls in this bag',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some balls to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}