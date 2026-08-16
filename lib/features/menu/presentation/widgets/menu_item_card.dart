import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/menu/presentation/screens/product_detail_screen.dart';
import 'package:solcafe/features/menu/presentation/providers/menu_stream_providers.dart';

class MenuItemCard extends ConsumerWidget {
  final String? category;

  const MenuItemCard({super.key, this.category});

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
          }
          final items = filteredItems;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;
              final String name = data['name'] ?? 'Item';
              final String subdesc = data['subdescription'] ?? data['description'] ?? '';
              final String imagePath = data['image'] ?? 'assets/images/coffee.jpg';
              final priceVal = data['price'];

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
                    onTap: () => viewitem(context, item.id, data),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: imagePath.isNotEmpty
                            ? (imagePath.startsWith('http')
                                ? Image.network(imagePath, fit: BoxFit.cover)
                                : Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee)))
                            : const Icon(Icons.coffee),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Text(
                          name,
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
                          subdesc,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      trailing: priceVal == null
                          ? const Icon(Icons.arrow_forward_ios,
                              color: Color(0xFFDCD1D1))
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C4A43),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "\$$priceVal",
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

  Future<void> viewitem(BuildContext context, String docid, Map<String, dynamic> existingData) async {
    try {
      Map<String, dynamic> data = existingData;
      if (data.isEmpty) {
        final doc = await FirebaseFirestore.instance.collection('menu').doc(docid).get();
        if (!doc.exists) throw Exception("Document not found");
        data = doc.data() as Map<String, dynamic>;
      }

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(itemid: docid, itemdata: data),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error opening item details")),
      );
    }
  }
}

// Backward compatibility alias
typedef Common = MenuItemCard;
