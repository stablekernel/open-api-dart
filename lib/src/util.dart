import 'json_object.dart';

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

Map<String, dynamic> stripNullAndEmpty(Map<String, dynamic> m) {
  var outMap = <String, dynamic>{};
  m.forEach((k, v) {
    if (v is Map) {
      var stripped = stripNullAndEmpty(v as Map<String, dynamic>);
      if (stripped.isNotEmpty) {
        outMap[k] = stripped;
      }
    } else if (v != null) {
      outMap[k] = v;
    }
  });
  return outMap;
}