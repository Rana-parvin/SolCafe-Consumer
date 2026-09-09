import 'package:flutter/material.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/domain/usecases/search_menu_items_usecase.dart';
import 'package:solcafe/features/menu/presentation/screens/product_detail_screen.dart';

class FirestoreSearchDelegate extends SearchDelegate<String> {
  final SearchMenuItemsUseCase? searchMenuItemsUseCase;

  FirestoreSearchDelegate({this.searchMenuItemsUseCase});

  @override
  String get searchFieldLabel => 'Search menu...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.solcafeColors;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfacePrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: colors.textMuted),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accentGold,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final colors = context.solcafeColors;
    return [
      IconButton(
        icon: Icon(Icons.clear, color: colors.textPrimary),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final colors = context.solcafeColors;
    return IconButton(
      icon: Icon(Icons.arrow_back, color: colors.textPrimary),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colors = context.solcafeColors;
    final suggestions = ['Espresso', 'Cappuccino', 'Latte', 'Mocha', 'Croissant'];
    final filtered = query.isEmpty
        ? suggestions
        : suggestions
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Container(
      color: colors.surfacePrimary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final suggestion = filtered[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.coffee, color: colors.accentGold),
              title: Text(suggestion, style: TextStyle(color: colors.textPrimary)),
              onTap: () {
                query = suggestion;
                showResults(context);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final colors = context.solcafeColors;

    if (query.isEmpty) {
      return Container(
        color: colors.surfacePrimary,
        child: Center(
          child: Text('Type to search menu items', style: TextStyle(color: colors.textSecondary)),
        ),
      );
    }

    return Container(
      color: colors.surfacePrimary,
      child: FutureBuilder<List<MenuItemEntity>>(
        future: searchMenuItemsUseCase != null
            ? searchMenuItemsUseCase!(query)
            : Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colors.accentGold),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No items found', style: TextStyle(color: colors.textSecondary)),
            );
          }

          final items = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final name = item.title;
              final image = item.image;
              final double price = double.tryParse(item.price) ?? 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.isNotEmpty
                        ? (image.startsWith('http://') || image.startsWith('https://')
                            ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
                            : Image.asset(image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, size: 40, color: colors.accentGold)))
                        : Icon(Icons.coffee, size: 40, color: colors.accentGold),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: colors.textPrimary),
                  ),
                  subtitle: Text(
                    "Price: \$${price.toStringAsFixed(2)}",
                    style: TextStyle(color: colors.accentGold, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          itemid: item.id,
                          itemdata: {
                            'name': item.title,
                            'title': item.title,
                            'description': item.description,
                            'price': item.price,
                            'image': item.image,
                            'category': item.category,
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

typedef CustomSearchDelegate = FirestoreSearchDelegate;
