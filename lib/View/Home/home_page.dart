import 'package:flutter/material.dart';
import '../../Constants/app_colors.dart';
import '../../GetIt/main_app.dart';
import '../../Models/user_model.dart';
import '../../Providers/tabs_provider.dart';
import '../../SharedWidgets/main_scaffold.dart';
import '../../Utils/tabs_enum.dart';
import '../Account/account_page.dart';
import '../AddEditPost/add_edit_post.dart';
import '../Feed/feed_page.dart';
import '../Friends/friends_page.dart';
import '../Notifications/notifications_page.dart';
import '../Settings/settings_page.dart';
import '../../locator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget showViewDueToCurrentTab({required Tabs currentTab}) {
    switch (currentTab.value) {
      case 0:
        return const FeedPage();
      case 1:
        return const NotificationsPage();
      case 2:
        return const FriendsPage();
      case 3:
        return const SettingsPage();
      default:
        return const FeedPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Tabs currentTab =
        Provider.of<TabsProvider>(context, listen: true).currentTab;
    UserModel? user = locator<MainApp>().user;
    return MainScaffold(
      body: showViewDueToCurrentTab(currentTab: currentTab),
      showBottomNavigationBar: true,
      appBarTitle: 'Monogram',
      appBarLeading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {},
          child: user?.profilePictureUrl != null
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AccountPage()));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user!.profilePictureUrl!,
                    ),
                    backgroundColor: Colors.black,
                  ),
                )
              : const ImageIcon(
                  AssetImage(
                    'assets/images/no_profile_picture.png',
                  ),
                  color: Colors.black,
                ),
        ),
      ),
      appBarLeadingWidth: 60,
      floatingActionButton: (currentTab.value == Tabs.feed.value)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddEditPost()));
              },
              backgroundColor: AppColors.monogramGrey,
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              ),
            )
          : null,
    );
  }
}
