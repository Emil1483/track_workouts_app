extension StringUtils on String {
  bool get isNullEmptyOrWhitespace => this == null || this.isEmpty || this.trim().isEmpty;

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

  String get camelcaseToUnderscore {
    String result = '';
    for (int i = 0; i < length; i++) {
      final char = this[i];
      if (char == char.toUpperCase()) result += '_';
      result += char.toLowerCase();
    }
    return result;
  }

  String get underscoreToCamelcase {
    String result = '';
    for (int i = 0; i < length; i++) {
      final char = this[i];
      if (char == '_') {
        i++;
        result += this[i].toUpperCase();
      } else {
        result += char;
      }
    }
    return result;
  }
}
