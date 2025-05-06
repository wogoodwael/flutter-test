import 'package:flutter/material.dart';
import 'package:flutter_task/core/lists.dart';
import 'package:flutter_task/core/strings.dart';
import 'package:flutter_task/presentation/widgets/app_bar.dart';
import 'package:flutter_task/presentation/widgets/items_content.dart';
import 'package:flutter_task/presentation/widgets/mobile_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          key: _scaffoldKey,

          drawer: constraints.maxWidth < 800 ? _buildDrawer(context) : null,
          appBar:
              constraints.maxWidth < 800
                  ? PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: MobileAppBar(
                      leading: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                  )
                  : PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: AppBarWidget(),
                  ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(children: [Expanded(child: ItemsContent())]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: .5 * MediaQuery.sizeOf(context).width,
      backgroundColor: Color(0xFF1E1E1E),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              accountName: Text(
                'John Doe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('john.doe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: ExactAssetImage(userOne),
              ),
            ),

            ...navItems.asMap().entries.map((entry) {
              int idx = entry.key;
              String item = entry.value;

              return SizedBox(
                width: 200,
                child: ListTile(
                  leading: _getIconForNavItem(item),
                  title: Text(item),
                  selected: _selectedIndex == idx,
                  selectedTileColor: Colors.grey.withOpacity(0.2),
                  selectedColor: Color(0xFFFFB84C),
                  onTap: () {
                    setState(() {
                      _selectedIndex = idx;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }),

            Divider(),

            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Icon _getIconForNavItem(String item) {
    switch (item) {
      case 'Items':
        return Icon(Icons.dashboard);
      case 'Pricing':
        return Icon(Icons.attach_money);
      case 'Info':
        return Icon(Icons.info_outline);
      case 'Tasks':
        return Icon(Icons.check_circle_outline);
      case 'Analytics':
        return Icon(Icons.analytics_outlined);
      default:
        return Icon(Icons.circle);
    }
  }
}
