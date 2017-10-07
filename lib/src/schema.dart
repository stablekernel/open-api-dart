import 'types.dart';
import 'util.dart';
import 'json_object.dart';

/// Represents a schema object in the OpenAPI specification.
class APISchemaObject extends APIObject {
  APISchemaObject();

  void decode(JSONObject json) {
    title = json.decode("title");
    format = json.decode("format");
    type = APITypeCodec.decode(json.decode("type"));
    description = json.decode("description");
    required = json.decode("required");
    example = json.decode("example");
    readOnly = json.decode("readOnly") ?? false;

    items = json.decode("items", inflate: () => new APISchemaObject());
    additionalProperties = json.decode("additionalProperties", inflate: () => new APISchemaObject());
    properties = json.decodeObjectMap("properties", () => new APISchemaObject());
  }

  String title;
  APIType type;
  String format;
  String description;

  String example;
  List<String> required = [];
  bool readOnly = false;

  APISchemaObject items;
  Map<String, APISchemaObject> properties;
  APISchemaObject additionalProperties;

  void encode(JSONObject json) {
    json.encode("type", APITypeCodec.encode(type));
    json.encode("required", required);
    json.encode("readOnly", readOnly);
    json.encode("title", title);
    json.encode("format", format);
    json.encode("description", description);
    json.encode("example", example);
    json.encodeObject("items", items);
    json.encodeObject("additionalProperties", additionalProperties);
    json.encodeObjectMap("properties", properties);
  }
}