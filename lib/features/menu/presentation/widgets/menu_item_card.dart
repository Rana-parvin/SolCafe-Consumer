import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
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

          final width = MediaQuery.of(context).size.width;
          if (width >= 600) {
            // Adaptive Grid layout for Tablets and Wide screens
            final crossAxisCount = SolCafeBreakpoints.getGridCrossAxisCount(
              context,
              smallPhone: 1,
              standardPhone: 1,
              tablet: 2,
              wide: 3,
            );

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: width >= 900 ? 3.2 : 2.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildItemTile(context, colors, item);
                  },
                ),
              ),
            );
          }

          // Compact list layout for mobile screens
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildItemTile(context, colors, item),
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

  Widget _buildItemTile(BuildContext context, SolCafeColors colors, MenuItemEntity item) {
    final String name = item.title;
    final String subdesc = item.description;
    final String imagePath = item.image;
    final priceVal = item.price;

    return Card(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
