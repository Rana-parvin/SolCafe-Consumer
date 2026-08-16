class MenuItemEntity {
  final String id;
  final String title;
  final String description;
  final String price;
  final String image;
  final String category;
  final List<String> sizes;

  const MenuItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.sizes = const ['S', 'M', 'L'],
  });
}
