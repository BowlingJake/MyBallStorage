import 'package:flutter_test/flutter_test.dart';
import 'package:bowlingarsenal_app/features/training/controllers/scoring_controller.dart';

void main() {
  group('ScoringController Tests', () {
    test('初始狀態應該正確', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      final state = controller.state;
      
      expect(state.rolls, isEmpty);
      expect(state.frames.length, equals(10));
      expect(state.currentFrameIndex, equals(0));
      expect(state.currentRollInFrame, equals(0));
      expect(state.isGameComplete, isFalse);
      expect(state.isEditMode, isFalse);
    });

    test('能正確處理投球選擇', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      
      // 第一球
      controller.processPinSelection(0, 7);
      
      expect(controller.state.rolls, equals([7]));
      expect(controller.state.currentFrameIndex, equals(0));
      expect(controller.state.currentRollInFrame, equals(1));
      
      // 第二球
      controller.processPinSelection(0, 2);
      
      expect(controller.state.rolls, equals([7, 2]));
      expect(controller.state.currentFrameIndex, equals(1));
      expect(controller.state.currentRollInFrame, equals(0));
    });

    test('能正確處理全倒', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      
      // Strike
      controller.processPinSelection(0, 10);
      
      expect(controller.state.rolls, equals([10]));
      expect(controller.state.currentFrameIndex, equals(1));
      expect(controller.state.currentRollInFrame, equals(0));
    });

    test('能正確重置遊戲', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      
      // 先投一些球
      controller.processPinSelection(0, 7);
      controller.processPinSelection(0, 2);
      
      // 重置
      controller.resetGame();
      
      expect(controller.state.rolls, isEmpty);
      expect(controller.state.currentFrameIndex, equals(0));
      expect(controller.state.currentRollInFrame, equals(0));
      expect(controller.state.isGameComplete, isFalse);
    });

    test('能正確撤銷投球', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      
      // 投兩球
      controller.processPinSelection(0, 7);
      controller.processPinSelection(0, 2);
      
      // 撤銷最後一球
      controller.undoLastRoll();
      
      expect(controller.state.rolls, equals([7]));
      expect(controller.state.currentFrameIndex, equals(0));
      expect(controller.state.currentRollInFrame, equals(1));
    });

    test('能正確切換編輯模式', () {
      final controller = ScoringController(scoringMethod: 'traditional');
      
      expect(controller.state.isEditMode, isFalse);
      
      controller.toggleEditMode();
      
      expect(controller.state.isEditMode, isTrue);
      
      controller.toggleEditMode();
      
      expect(controller.state.isEditMode, isFalse);
    });
  });
} 