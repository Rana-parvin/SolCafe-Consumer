class StringUtils {
  static String? capitalizeFullName(String? name) {
    if (name == null || name.trim().isEmpty) return name;
    return name
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }
}
