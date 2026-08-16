import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/menu/presentation/widgets/search_item_tile.dart';
import 'package:solcafe/features/menu/presentation/screens/product_detail_screen.dart';

class FirestoreSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search menu...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filtered = query.isEmpty
        ? suggestions 
        : searchterms
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final suggestion = filtered[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.coffee),
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context); 
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type to search menu items'));
    }

    final searchQuery = query.toLowerCase();

    final stream = FirebaseFirestore.instance
        .collection('menu')
        .where('nameLower', arrayContains: searchQuery) 
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: const ListTile(
                  leading: Icon(Icons.coffee, size: 50),
                  title: Text('Loading...', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Please wait...'),
                ),
              );
            },
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final name = data['name'] ?? 'Item';
            final image = data['image'] ?? '';
            final price = double.tryParse(data['price'].toString()) ?? 0.0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: image.isNotEmpty
                    ? (image.startsWith('http://') || image.startsWith('https://')
                        ? Image.network(image, width: 60, height: 60, fit: BoxFit.cover)
                        : Image.asset(image, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 60)))
                    : const Icon(Icons.image, size: 60),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Price: ₹${price.toStringAsFixed(2)}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        itemid: docs[index].id,
                        itemdata: data,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Backward compatibility alias
typedef CustomSearchDelegate = FirestoreSearchDelegate;
