/// Remove any entries with a null value from the list and convert the type.
Map<K, V> removeNullsFromMap<K, V>(Map<K, V?>? map) {
  if (map == null) return <K, V>{};

  final fixed = <K, V>{};

  // remove nulls
  for (final key in map.keys) {
    final value = map[key];
    if (value != null) {
      fixed[key] = value;
    }
  }

  return fixed;
}
