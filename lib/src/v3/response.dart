import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/media_type.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  String description;
  Map<String, APIHeader> headers = {};
  Map<String, APIMediaType> content;

  // Currently missing:
  // links

  void decode(JSONObject object) {
    super.decode(object);

    description = object.decode("description");
    content = object.decodeObjectMap("content", () => new APIMediaType());
    headers = object.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("description", description);
    object.encodeObjectMap("headers", headers);
    object.encodeObjectMap("content", content);
  }
}
