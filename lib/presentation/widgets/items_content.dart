import 'package:flutter/material.dart';
import 'package:flutter_task/core/strings.dart';
import 'package:flutter_task/core/styles.dart';
import 'package:flutter_task/presentation/widgets/item_grid.dart';

class ItemsContent extends StatelessWidget {
  const ItemsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items',
                style:interRegular32
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:Image.asset(filterIcon)
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text('Add a New Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFB84C),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Item grid
          Expanded(child: FirebaseItemGrid()),
        ],
      ),
    );
  }
}
