import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class TournamentSection extends StatelessWidget {

  const TournamentSection({
    super.key,
    this.tournamentItems,
    this.onSeeAllPressed,
    this.onItemPressed,
  });
  final List<Map<String, String>>? tournamentItems;
  final VoidCallback? onSeeAllPressed;
  final void Function(int index)? onItemPressed;

  @override
  Widget build(BuildContext context) {
    final items = tournamentItems ?? _getDefaultTournamentItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Tournament', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),),
            TextButton(
              onPressed: onSeeAllPressed ?? () => print('See All Tournaments'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GFCard(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              content: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['photoUrl']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.event, 
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), 
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name']!, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ) ?? TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),),
                        const SizedBox(height: 4),
                        Text('Location: ${item['location']}', style: Theme.of(context).textTheme.bodyMedium ?? TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),),
                        Text('AVG: ${item['avg']}', style: Theme.of(context).textTheme.bodyMedium ?? TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),),
                      ],
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        if (onItemPressed != null) {
                          onItemPressed!(index);
                        } else {
                          print('Detail of Tournament ${index + 1}');
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text('Detail'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  List<Map<String, String>> _getDefaultTournamentItems() {
    return List.generate(
      3,
      (index) => {
        'photoUrl': 'https://via.placeholder.com/80x80/f66b97/FFFFFF?Text=Event${index+1}',
        'name': 'Tournament Name ${index + 1}',
        'location': 'Location ${index + 1}',
        'avg': (200 + index * 5.5).toStringAsFixed(2),
      },
    );
  }
} 