import 'package:open_api/src/json_object.dart';
import 'package:meta/meta.dart';

class APIException implements Exception {
  APIException(this.message);

  String message;

  String toString() => message;
}

abstract class APIObject {
  APIObject();

  factory APIObject.reference(String referenceURI) {
    return new _APIReferenceObject(referenceURI);
  }

  String referenceURI;
  Map<String, dynamic> extensions = {};

  @mustCallSuper
  void decode(JSONObject object) {
    final extensionKeys = object.keys.where((k) => k.startsWith("x-"));
    extensionKeys.forEach((key) {
      extensions[key] = object.decodeRaw(key);
    });
  }

  @mustCallSuper
  void encode(JSONObject object) {
    final invalidKeys = extensions.keys.where((key) => !key.startsWith("x-")).map((key) => "'$key'").toList();
    if (invalidKeys.length > 0) {
      throw new APIException(
          "extension keys must start with 'x-'. The following keys are invalid: ${invalidKeys.join(", ")}");
    }

    extensions.forEach((key, value) {
      object.encode(key, value);
    });
  }
}

class _APIReferenceObject extends APIObject {
  _APIReferenceObject(String referenceURI) {
    this.referenceURI = referenceURI;
  }
}