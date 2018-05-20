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

  void decode(JSONObject object) {
    super.decode(object);

    description = object.decode("description");
    schema = object.decodeObject("schema", () => new APISchemaObject());
    headers = object.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encodeObjectMap("headers", headers);
    object.encodeObject("schema", schema);
    object.encode("description", description);
  }
}
