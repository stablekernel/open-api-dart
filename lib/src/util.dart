import 'json_object.dart';
import 'document.dart';

class APIException implements Exception {
  APIException(this.message);

  String message;

  String toString() => message;
}

abstract class APIObject {
  void encodeInto(JSONObject object);

//  void resolve(APIDocument document);
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