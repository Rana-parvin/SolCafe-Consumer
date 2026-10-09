class Sizelogic {
  static List<String> sizesfor(String category) {
    switch (category.toLowerCase()) {
      case "coffee":
      case "non coffee":
        return ["S", "M", "L"];
      case "cake":
        return ["1/2 kg", "1 kg", "2 kg"];
      case "pastry":
        return ["small", "regular"];
      default:
        return [];
    }
  }

  static double calculateUnitPrice(double basePrice, String size, String category) {
    final cat = category.toLowerCase();
    final sz = size.toLowerCase();

    if (cat.contains("cake")) {
      if (sz == "1 kg") return basePrice * 1.8;
      if (sz == "2 kg") return basePrice * 3.4;
      return basePrice;
    }

    if (cat.contains("pastry")) {
      if (sz == "regular") return basePrice * 1.3;
      return basePrice;
    }

    if (sz == "m") return basePrice * 1.25;
    if (sz == "l") return basePrice * 1.5;
    return basePrice;
  }
}

