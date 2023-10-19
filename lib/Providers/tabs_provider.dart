import 'package:flutter/cupertino.dart';
import '../Utils/tabs_enum.dart';

class TabsProvider with ChangeNotifier {
  Tabs _currentTab = Tabs.feed;
  Tabs get currentTab => _currentTab;

  void changeCurrentTab(Tabs newTab) {
    _currentTab = newTab;
    notifyListeners();
  }
}
