import 'package:flutter/material.dart';
import 'package:flutter_task/core/strings.dart';
import 'package:flutter_task/core/styles.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
        Image.asset(logo),

          Spacer(),

          // Nav items
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  _buildNavItem('Items', true),
                  _buildNavItem('Pricing', false),
                  _buildNavItem('Info', false),
                  _buildNavItem('Tasks', false),
                  _buildNavItem('Analytics', false),
                ],
              );
            },
          ),

          SizedBox(width: 16),

        Image.asset(settings, color: Colors.white,),

          SizedBox(width: 16),

        Image.asset(notification , color: Colors.white,),

          SizedBox(width: 16),

          // Profile button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange,
                  backgroundImage: ExactAssetImage(userOne)
                ),
                SizedBox(width: 8),
                Text('John Doe' , style: interRegular,),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_sharp, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Color(0xFFFFB84C) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}
