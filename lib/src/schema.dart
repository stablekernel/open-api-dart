import 'types.dart';
import 'util.dart';
import 'json_object.dart';

/// Represents a schema object in the OpenAPI specification.
class APISchemaObject implements APIObject {
  APISchemaObject();

  APISchemaObject.fromJSON(JSONObject json) {
    title = json.decode("title");
    format = json.decode("format");
    type = APITypeCodec.decode(json.decode("type"));
    description = json.decode("description");
    required = json.decode("required");
    example = json.decode("example");
    readOnly = json.decode("readOnly") ?? false;

    items = json.decode("items", objectDecoder: (v) => new APISchemaObject.fromJSON(v));

    properties = json.decodeObjectMap("properties", (v) => new APISchemaObject.fromJSON(v));
    additionalProperties = json.decode("additionalProperties", objectDecoder: (v) => new APISchemaObject.fromJSON(v));
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

  void encodeInto(JSONObject json) {
    json.encode("type", APITypeCodec.encode(type));
    json.encode("required", required);
    json.encode("readOnly", readOnly);
    json.encode("title", title);
    json.encode("format", format);
    json.encode("description", description);
    json.encode("example", example);
    json.encodeObject("items", items);
    json.encodeObjectMap("properties", properties);
    json.encodeObject("additionalProperties", additionalProperties);
  }
}