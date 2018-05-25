import 'package:meta/meta.dart';
import 'package:codable/codable.dart';

export 'package:codable/codable.dart';

class APIObject extends Coding {
  Map<String, dynamic> extensions = {};

  @mustCallSuper
  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    final extensionKeys = object.keys.where((k) => k.startsWith("x-"));
    extensionKeys.forEach((key) {
      extensions[key] = object.decode(key);
    });
  }

  @mustCallSuper
  void encode(KeyedArchive object) {
    final invalidKeys = extensions.keys.where((key) => !key.startsWith("x-")).map((key) => "'$key'").toList();
    if (invalidKeys.length > 0) {
      throw new ArgumentError(
          "extension keys must start with 'x-'. The following keys are invalid: ${invalidKeys.join(", ")}");
    }

    extensions.forEach((key, value) {
      object.encode(key, value);
    });
  }
}