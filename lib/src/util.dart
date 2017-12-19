import 'package:open_api/src/json_object.dart';

class APIException implements Exception {
  APIException(this.message);

  String message;

  String toString() => message;
}

abstract class APIObject {
  String referenceURI;

  void decode(JSONObject object);
  void encode(JSONObject object);
}