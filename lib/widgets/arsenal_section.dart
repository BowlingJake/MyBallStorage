import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ArsenalSection extends StatelessWidget {
  final List<Map<String, String>>? arsenalItems;
  final VoidCallback? onSeeAllPressed;
  final void Function(int index)? onItemPressed;

  const ArsenalSection({
    Key? key,
    this.arsenalItems,
    this.onSeeAllPressed,
    this.onItemPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = arsenalItems ?? _getDefaultArsenalItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Arsenal', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            )),
            TextButton(
              onPressed: onSeeAllPressed ?? () => print('See All Arsenal'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text('See All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: Container(
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return SizedBox(
                  width: 170,
                  child: GFCard(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    boxFit: BoxFit.cover,
                    image: Image.network(
                      item['photoUrl']!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surface,
                          child: Icon(
                            Icons.sports_baseball, 
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), 
                            size: 50
                          ),
                        );
                      },
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4),
                        Text(item['name']!, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ) ?? TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ), overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4),
                        Text('Core: ${item['core']}', style: Theme.of(context).textTheme.bodySmall ?? TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ), overflow: TextOverflow.ellipsis),
                        Text('Cover: ${item['cover']}', style: Theme.of(context).textTheme.bodySmall ?? TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    buttonBar: GFButtonBar(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      children: <Widget>[
                        GFButton(
                          onPressed: () {
                            if (onItemPressed != null) {
                              onItemPressed!(index);
                            } else {
                              print('View Arsenal Item ${index + 1}');
                            }
                          },
                          text: 'View',
                          blockButton: true,
                          size: GFSize.SMALL,
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getDefaultArsenalItems() {
    return List.generate(
      5,
      (index) => {
        'photoUrl': 'https://via.placeholder.com/170x100/771796/FFFFFF?Text=Ball${index+1}',
        'name': 'Ball Name ${index + 1}',
        'core': 'Core Type ${index + 1}',
        'cover': 'Cover Stock ${index + 1}',
      },
    );
  }
} 