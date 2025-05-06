import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/lists.dart';
import 'package:flutter_task/core/strings.dart';
import 'package:intl/intl.dart';

class FirebaseItemGrid extends StatelessWidget {
  const FirebaseItemGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Listen to the 'items' collection in Firestore
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Error loading data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // This will rebuild the widget and retry the stream connection
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Handle empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No items found', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // Convert Firestore documents to a list of maps
        final items =
            snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              // Add the document ID to the map
              return {'id': doc.id, ...data};
            }).toList();

        // Build the grid with the loaded data
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
            final isMobile = constraints.maxWidth < 600;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: _getChildAspectRatio(constraints.maxWidth),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  index: index,
                  itemFireBase: items[index],
                  isMobile: isMobile,
                  notMoreThanTwo: itemList[index]['notMoreThanTwo'] ?? false,
                );
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width < 600) {
      return 1;
    } else if (width < 900) {
      return 2;
    } else if (width < 1200) {
      return 3;
    } else if (width < 1300) {
      return 4;
    } else if (width < 1500) {
      return 5;
    } else {
      return 6;
    }
  }

  double _getChildAspectRatio(double width) {
    if (width < 300) {
      return .6;
    } else if (width < 400) {
      return .9;
    } else if (width < 500) {
      return 1.4;
    } else if (width < 600) {
      return 1.7;
    } else if (width < 700) {
      return 1;
    } else if (width < 800) {
      return 1.1;
    } else if (width < 900) {
      return 1.4;
    } else if (width < 1100) {
      return 1.1;
    } else if (width < 1200) {
      return 1.2;
    } else if (width < 1300) {
      return 1;
    } else {
      return .8;
    }
  }
}

// Modified ItemCard to handle null values gracefully from Firebase
class ItemCard extends StatelessWidget {
  final Map<String, dynamic> itemFireBase;
  final int index;
  final bool isMobile;
  final bool notMoreThanTwo;

  const ItemCard({
    super.key,
    required this.itemFireBase,
    this.isMobile = false,
    required this.notMoreThanTwo,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_getImagePath(itemList[index]['image'])),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // More options button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              // Pending approval tag
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    border: Border.all(color: const Color(0xffC25F30)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pending Approval',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  itemFireBase['title'] ?? 'Untitled',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Date info
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: isMobile ? 14 : 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      itemList[index]['nights'] != null
                          ? Text(
                            '${itemList[index]['nights']} Nights (${itemFireBase['date'] != null ? DateFormat('MMM d, yyyy - h:mm a').format((itemFireBase['date'] as Timestamp).toDate()) : 'No dates'})',
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 12,
                              color: Colors.grey,
                            ),
                          )
                          : Text(
                            itemFireBase['date'] != null
                                ? DateFormat(
                                  'MMM d, yyyy - h:mm a',
                                ).format(DateTime.parse(itemFireBase['date']))
                                : 'No dates',
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 12,
                              color: Colors.grey,
                            ),
                          ),
                    ],
                  ),
                ),
                // User avatars and tasks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User avatars
                    SizedBox(
                      width: 80,
                      height: 24,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 5,
                            child: _buildUserAvatar(Colors.orange, userOne),
                          ),
                          Positioned(
                            left: 16,
                            child: _buildUserAvatar(Colors.blue, userTwo),
                          ),
                          notMoreThanTwo
                              ? const SizedBox()
                              : Positioned(
                                left: 27,
                                child: _buildUserAvatar(
                                  Colors.green,
                                  userThree,
                                ),
                              ),
                          notMoreThanTwo
                              ? const SizedBox()
                              : Positioned(
                                left: 35,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF1E1E1E),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${(itemList[index]['userCount'] ?? 9) - 3}',
                                      style: TextStyle(
                                        fontSize: isMobile ? 8 : 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                    //
                    // Tasks count
                    Spacer(),
                    Text(
                      '${itemFireBase['tasks'] ?? 0} unfinished tasks',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(Color color, String img) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
      ),
      child: Image.asset(img),
    );
  }

  String _getImagePath(String filename) {
    switch (filename) {
      case 'palm_trees.jpg':
        return palmTree;
      case 'city_skyline.jpg':
        return city;
      case 'ocean_dock.jpg':
        return ocean;
      default:
        return ocean;
    }
  }
}
