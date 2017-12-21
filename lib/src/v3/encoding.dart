import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';

class APIEncoding extends APIObject {
  String contentType;
  Map<String, APIHeader> headers = {};

  // Currently missing:
  // style, explode, allowReserved

  void decode(JSONObject object) {
    super.decode(object);

    contentType = object.decode("contentType");
    headers = object.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("contentType", contentType);
    object.encodeObjectMap("headers", headers);
  }
}
