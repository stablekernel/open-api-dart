import 'package:open_api/src/v2/schema.dart';
import 'package:open_api/src/v2/header.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/json_object.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  String description = "";
  APISchemaObject schema;
  Map<String, APIHeader> headers = {};

  void decode(JSONObject json) {
    description = json.decode("description");
    schema = json.decode("schema", inflate: () => new APISchemaObject());
    headers = json.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject json) {
    json.encodeObjectMap("headers", headers);
    json.encodeObject("schema", schema);
    json.encode("description", description);
  }
}