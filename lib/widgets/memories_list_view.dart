import 'package:flutter/material.dart';

class MemoriesListView extends StatelessWidget {
  final List<int> randomPhotoCounts;
  final List<List<int>> randomImageIndices;
  final List<String> randomImageUrls;
  final ScrollController scrollController;
  const MemoriesListView({
    super.key,
    required this.randomPhotoCounts,
    required this.randomImageIndices,
    required this.randomImageUrls,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          final months = ['January', 'February', 'March', 'April', 'May', 'June'];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      months[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${randomPhotoCounts[index]} moments',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 110,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(randomPhotoCounts[index], (photoIndex) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: index == 4 && photoIndex == 2 ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.red, width: 3),
                          ) : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              randomImageUrls[randomImageIndices[index][photoIndex]],
                              height: 110,
                              width: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
