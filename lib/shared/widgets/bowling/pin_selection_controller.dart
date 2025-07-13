part of pin_selection;

class PinSelectionController {
  late PinSelectionWidgetState _state;

  void attach(PinSelectionWidgetState state) {
    _state = state;
  }

  void strike() => _state.strike();
  void leave(int pin) => _state.leave(pin);
  void spare() => _state.spare();
  void clear() => _state.clear();
  List<bool> get pinState => _state.pinState;
} 