import 'package:flutter/material.dart';

class CassetteImageGrid extends StatelessWidget {
  final List<String> imageList;
  final Function(int) onImageTap;
  final List<GlobalKey> imageKeys;
  
  const CassetteImageGrid({
    super.key,
    required this.imageList,
    required this.onImageTap,
    required this.imageKeys,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: (imageList.length / 3).ceil(),
        itemBuilder: (context, rowIndex) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(3, (columnIndex) {
                final imageIndex = rowIndex * 3 + columnIndex;
                
                if (imageIndex >= imageList.length) {
                  return Expanded(child: SizedBox());
                }
                
                return Expanded(
                  child: GestureDetector(
                    key: ValueKey("cassette_item_1"),
                    onTap: () => onImageTap(imageIndex),
                    child: Container(
                      key: imageKeys[imageIndex],
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imageList[imageIndex],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[600],
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
