extension MapUtils<U, V> on Map<U, V> {
  Map<U, V> copy() => Map<U, V>.from(this);
}

extension Maps<U, V> on List<Map<U, V>> {
  List<Map<U, V>> copy() => List.generate(length, (index) => this[index].copy());
}