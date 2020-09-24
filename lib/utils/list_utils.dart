extension ListUtils<U> on List<U> {
  String format(Function(U) toString, [String bindingWord = 'and']) {
    if (isEmpty) return '';
    if (length == 1) return toString(first);

    String result = '';
    for (int i = 0; i < length; i++) {
      result += toString(this[i]);
      if (i < length - 2) {
        result += ', ';
      } else if (i < length - 1) {
        result += ' $bindingWord ';
      }
    }
    return result;
  }
}
