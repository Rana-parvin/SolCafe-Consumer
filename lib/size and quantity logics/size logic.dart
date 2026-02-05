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

  
}
