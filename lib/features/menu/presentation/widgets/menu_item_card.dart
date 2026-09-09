import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/presentation/providers/menu_provider.dart';
import 'package:solcafe/features/menu/presentation/screens/product_detail_screen.dart';

class MenuItemCard extends ConsumerWidget {
  final String? category;

  const MenuItemCard({super.key, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(menuItemsStreamProvider(category));
    final colors = context.solcafeColors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                "No items found in this category",
                style: TextStyle(color: colors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final String name = item.title;
              final String subdesc = item.description;
              final String imagePath = item.image;
              final priceVal = item.price;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => viewitem(context, item),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: imagePath.isNotEmpty
                                  ? (imagePath.startsWith('http')
                                      ? Image.network(imagePath, fit: BoxFit.cover)
                                      : Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, color: colors.accentGold, size: 30)))
                                  : Icon(Icons.coffee, color: colors.accentGold, size: 30),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subdesc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.accentGoldSubtle,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.accentGold.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              "\$$priceVal",
                              style: TextStyle(
                                color: colors.accentGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colors.accentGold),
        ),
        error: (err, _) => Center(
          child: Text(
            "Error: $err",
            style: TextStyle(color: colors.statusCancelledText),
          ),
        ),
      ),
    );
  }

  void viewitem(BuildContext context, MenuItemEntity item) {
    final Map<String, dynamic> itemdata = {
      'name': item.title,
      'title': item.title,
      'description': item.description,
      'price': item.price,
      'image': item.image,
      'category': item.category,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(itemid: item.id, itemdata: itemdata),
      ),
    );
  }
}

typedef Common = MenuItemCard;
