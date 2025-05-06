import 'package:flutter/material.dart';
import 'package:flutter_task/core/strings.dart';

class MobileAppBar extends StatefulWidget {
  const MobileAppBar({super.key, required this.leading});
  final Widget leading;

  @override
  _MobileAppBarState createState() => _MobileAppBarState();
}

class _MobileAppBarState extends State<MobileAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: widget.leading,
        title: Row(children: [Image.asset(logo)]),
        actions: [
          IconButton(icon: Image.asset(settings), onPressed: () {}),
          IconButton(icon: Image.asset(notification), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: ExactAssetImage(userOne),
            ),
          ),
        ],
      ),
    );
  }
}
