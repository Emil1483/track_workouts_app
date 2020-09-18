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

  String get formatFromUnderscore => this.replaceAll('_', ' ').capitalizeFirstLetters;

  String get capitalizeFirstLetters {
    if (this.length <= 1) return this.toUpperCase();
    var words = this.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  String get camelcaseToUnderscore => formatFromCamelcase.replaceAll(' ', '_').toLowerCase();
}
