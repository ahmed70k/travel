import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveSidebarItemNotifier extends Notifier<String> {
  @override
  String build() => 'لوحة التحكم';

  void setItem(String item) {
    state = item;
  }
}

final activeSidebarItemProvider =
    NotifierProvider<ActiveSidebarItemNotifier, String>(() {
  return ActiveSidebarItemNotifier();
});
