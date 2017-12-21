import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v2/property.dart';

/// Represents a schema object in the OpenAPI specification.
class APISchemaObject extends APIProperty {
  APISchemaObject();

  String title;
  String description;
  String example;
  List<String> required = [];
  bool readOnly = false;

  /// Valid when type == array
  APISchemaObject items;

  /// Valid when type == null
  Map<String, APISchemaObject> properties;

  /// Valid when type == object
  APISchemaObject additionalProperties;

  @override
  APISchemaRepresentation get representation {
    if (properties != null) {
      return APISchemaRepresentation.structure;
    }

    return super.representation;
  }

  void decode(JSONObject json) {
    super.decode(json);

    title = json.decode("title");
    description = json.decode("description");
    required = json.decode("required");
    example = json.decode("example");
    readOnly = json.decode("readOnly") ?? false;

    items = json.decode("items", inflate: () => new APISchemaObject());
    additionalProperties = json.decode("additionalProperties",
        inflate: () => new APISchemaObject());
    properties =
        json.decodeObjectMap("properties", () => new APISchemaObject());
  }

  void encode(JSONObject json) {
    super.encode(json);

    json.encode("title", title);
    json.encode("description", description);
    json.encode("required", required);
    json.encode("example", example);
    json.encode("readOnly", readOnly);

    json.encodeObject("items", items);
    json.encodeObject("additionalProperties", additionalProperties);
    json.encodeObjectMap("properties", properties);
  }
}
