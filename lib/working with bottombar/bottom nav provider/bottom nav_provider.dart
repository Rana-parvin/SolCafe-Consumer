import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int newIndex) => state = newIndex;
}

final bottomNavProvider = NotifierProvider<BottomNavNotifier, int>(BottomNavNotifier.new);




