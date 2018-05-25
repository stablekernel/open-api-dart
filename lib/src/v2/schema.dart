import 'package:codable/cast.dart' as cast;
import 'package:codable/codable.dart';
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

  @override
  Map<String, cast.Cast> get castMap => {"required": cast.List(cast.String)};

  void decode(KeyedArchive json) {
    super.decode(json);

    title = json.decode("title");
    description = json.decode("description");
    required = json.decode("required");
    example = json.decode("example");
    readOnly = json.decode("readOnly") ?? false;

    items = json.decodeObject("items", () => new APISchemaObject());
    additionalProperties = json.decodeObject("additionalProperties", () => new APISchemaObject());
    properties =
        json.decodeObjectMap("properties", () => new APISchemaObject());
  }

  void encode(KeyedArchive json) {
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
