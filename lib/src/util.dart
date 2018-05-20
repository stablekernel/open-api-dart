import 'package:open_api/src/json_object.dart';
import 'package:meta/meta.dart';

abstract class APIObject {
  APIObject();

  Uri referenceURI;
  Map<String, dynamic> extensions = {};

  @mustCallSuper
  void decode(JSONObject object) {
    referenceURI = object.referenceURI;
    final extensionKeys = object.keys.where((k) => k.startsWith("x-"));
    extensionKeys.forEach((key) {
      extensions[key] = object.decode(key);
    });
  }

  @mustCallSuper
  void encode(JSONObject object) {
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