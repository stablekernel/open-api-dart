import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';

class APIEncoding extends APIObject {
  String contentType;
  Map<String, APIHeader> headers = {};

  // Currently missing:
  // style, explode, allowReserved

  void decode(JSONObject json) {
    contentType = json.decode("contentType");
    headers = json.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject json) {
    json.encode("contentType", contentType);
    json.encodeObjectMap("headers", headers);
  }
}
