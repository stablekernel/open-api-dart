import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/media_type.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  String description = "";
  Map<String, APIHeader> headers = {};
  Map<String, APIMediaType> content;

  // Currently missing:
  // links

  void decode(JSONObject json) {
    description = json.decode("description");
    content = json.decodeObjectMap("content", () => new APIMediaType());
    headers = json.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject json) {
    json.encode("description", description);
    json.encodeObjectMap("headers", headers);
    json.encodeObjectMap("content", content);
  }
}