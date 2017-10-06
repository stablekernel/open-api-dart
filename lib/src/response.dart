import 'schema.dart';
import 'header.dart';
import 'util.dart';
import 'json_object.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  APIResponse.fromJSON(JSONObject json) {
    description = json.decode("description");
    schema = json.decode("schema", objectDecoder: (v) => new APISchemaObject.fromJSON(v));
    headers = json.decodeObjectMap("headers", (v) => new APIHeader.fromJSON(v));
  }

  String description = "";
  APISchemaObject schema;
  Map<String, APIHeader> headers = {};

  void encodeInto(JSONObject json) {
    json.encodeObjectMap("headers", headers);
    json.encodeObject("schema", schema);
    json.encode("description", description);
  }
}