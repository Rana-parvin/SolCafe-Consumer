import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/crud/view%20in%20detail.dart';
import 'package:solcafe/working%20with%20tabbar/stream_provider.dart';

class Common extends ConsumerWidget {
  final String? category;

  const Common({super.key, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(allItemsProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: itemsAsync.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No items found"));
          }
  final filteredItems = category == null || category == "All"
      ? snapshot.docs
      : snapshot.docs.where((doc) => doc['category'] == category).toList();

  if (filteredItems.isEmpty) {
    return const Center(child: Text("No items found in this category"));
  }  final items = filteredItems;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return SizedBox(
                height: 128,
                child: Card(
                  elevation: 2,
                  shadowColor: const Color.fromARGB(255, 188, 143, 126),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => viewitem(context, item.id),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        child: Image.asset(item['image']),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 5),
                        child: Text(
                          item['subdescription'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      trailing: item['price'] == null
                          ? const Icon(Icons.arrow_forward_ios,
                              color: Color(0xFFDCD1D1))
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              width: 55,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C4A43),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "\$${item['price']}",
                                style: const TextStyle(
                                    color: Colors.amberAccent, fontSize: 12),
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Future<void> viewitem(BuildContext context, String docid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('menu').doc(docid).get();
      if (!doc.exists) throw Exception("Document not found");

      final data = doc.data() as Map<String, dynamic>;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Viewindetail(itemid: doc.id, itemdata: data),
        ),
      );
    } catch (e) {
      print("Error reading item: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error reading item")));
    }
  }
}
