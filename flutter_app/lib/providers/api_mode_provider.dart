import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiModeNotifier extends StateNotifier<bool> {
  ApiModeNotifier() : super(false); // Default to demo mode (false)
  
  void setApiMode(bool isEnabled) {
    state = isEnabled;
  }
  
  void toggleApiMode() {
    state = !state;
  }
}

final apiModeProvider = StateNotifierProvider<ApiModeNotifier, bool>((ref) {
  return ApiModeNotifier();
});
