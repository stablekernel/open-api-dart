import 'package:open_api_forked/src/object.dart';
import 'package:open_api_forked/src/v2/header.dart';
import 'package:open_api_forked/src/v2/schema.dart';

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse extends APIObject {
  APIResponse();

  String? description = "";
  APISchemaObject? schema;
  Map<String, APIHeader?>? headers = {};

  void decode(KeyedArchive object) {
    super.decode(object);

    description = object.decode("description");
    schema = object.decodeObject("schema", () => APISchemaObject());
    headers = object.decodeObjectMap("headers", () => APIHeader());
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encodeObjectMap("headers", headers);
    object.encodeObject("schema", schema);
    object.encode("description", description);
  }
}
