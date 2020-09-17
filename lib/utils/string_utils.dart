extension StringUtils on String {
  String get formatFromCamelcase {
    String result = '';
    for (int i = 0; i < this.length; i++) {
      final char = this[i];
      if (char == char.toUpperCase()) result += ' ';
      result += char;
    }
    return result[0].toUpperCase() + result.substring(1);
  }
}