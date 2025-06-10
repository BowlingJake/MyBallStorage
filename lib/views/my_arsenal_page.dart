import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../models/arsenal_ball.dart';
import '../models/ball_bag_type.dart';
import '../widgets/action_button_pair.dart';
import '../widgets/bag_selector_widget.dart';
import '../widgets/ball_grid_widget.dart';
import '../widgets/ball_bag_options_dialog.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);
final selectedBagTypeProvider = StateProvider<BallBagType>((ref) => BallBagType.all);

/// Mock data for the arsenal grid.
final userBallsProvider = Provider<List<ArsenalBall>>((ref) => [
      ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH Hybrid Reactive',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 1, 15),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'Phaze II',
        core: 'R2S Pearl',
        cover: 'R2S Pearl Reactive',
        layout: '5x3x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 2, 20),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'IQ Tour',
        core: 'C3 Centripetal Control Core',
        cover: 'R2S Solid Reactive',
        layout: '4.5x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 3, 10),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Hustle Ink',
        core: 'VTC-P18',
        cover: 'VTC-S19 Solid Reactive',
        layout: '5x4x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Roto Grip',
        dateAdded: DateTime(2024, 1, 5),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Code Black',
        core: 'RAD4 Core',
        cover: 'HK22 Solid Reactive',
        layout: '4.5x3.5x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 4, 2),
        bagType: BallBagType.competition,
      ),
    ]);

/// Filter balls based on selected bag type
final filteredBallsProvider = Provider<List<ArsenalBall>>((ref) {
  final allBalls = ref.watch(userBallsProvider);
  final selectedBagType = ref.watch(selectedBagTypeProvider);
  
  if (selectedBagType == BallBagType.all) {
    return allBalls;
  }
  
  return allBalls.where((ball) => ball.bagType == selectedBagType).toList();
});

/// A simple page showing the user's arsenal.
class MyArsenalPage extends ConsumerWidget {
  const MyArsenalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomIndexProvider);
    final selectedBagType = ref.watch(selectedBagTypeProvider);
    final balls = ref.watch(filteredBallsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Arsenal'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Bag selector and create ball bag button row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Bag selector dropdown (縮短)
                Expanded(
                  flex: 3,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<BallBagType>(
                      value: selectedBagType,
                      hint: Text(
                        '選擇球袋',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      items: BallBagType.values.map((bagType) {
                        return DropdownMenuItem<BallBagType>(
                          value: bagType,
                          child: Text(
                            bagType.displayName,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (BallBagType? value) {
                        if (value != null) {
                          ref.read(selectedBagTypeProvider.notifier).state = value;
                        }
                      },
                      isExpanded: true,
                      buttonStyleData: ButtonStyleData(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                            width: 1,
                          ),
                          color: theme.colorScheme.surface,
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        offset: const Offset(0, -4),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Create ball bag button
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        _showBallBagOptionsDialog(context, ref);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text(
                        'Create Ball Bag',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Balls grid
          Expanded(
            child: BallGridWidget(balls: balls),
          ),
        ],
      ),
      // Analyze Chart 浮動按鈕在右下角（圓形）
      floatingActionButton: Tooltip(
        message: 'Analyze Chart',
        child: FloatingActionButton(
          onPressed: () {
            // TODO: 實現分析圖表功能
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analyze Chart功能待實現')),
            );
          },
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          shape: const CircleBorder(),
          child: const Icon(Icons.insights, size: 28),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            ref.read(bottomIndexProvider.notifier).state = index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Arsenal'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }



  void _showBallBagOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return const BallBagOptionsDialog();
      },
    );
  }


}
