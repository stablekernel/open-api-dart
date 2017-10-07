import 'schema.dart';
import 'header.dart';
import 'util.dart';
import 'json_object.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  void decode(JSONObject json) {
    description = json.decode("description");
    schema = json.decode("schema", inflate: () => new APISchemaObject());
    headers = json.decodeObjectMap("headers", () => new APIHeader());
  }

  String description = "";
  APISchemaObject schema;
  Map<String, APIHeader> headers = {};

  void encode(JSONObject json) {
    json.encodeObjectMap("headers", headers);
    json.encodeObject("schema", schema);
    json.encode("description", description);
  }
}