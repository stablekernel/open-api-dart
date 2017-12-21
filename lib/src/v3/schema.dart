import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/types.dart';

/// Represents a schema object in the OpenAPI specification.
class APISchemaObject extends APIObject {
  APISchemaObject();

  /* JSON Schema */
  String title;
  num maximum;
  bool exclusiveMaximum;
  num minimum;
  bool exclusiveMinimum;
  int maxLength;
  int minLength;
  String pattern;
  int maxItems;
  int minItems;
  bool uniqueItems;
  num multipleOf;
  int maxProperties;
  int minProperties;
  List<String> required;
  List<dynamic> enumerated;

  /* Modified JSON Schema for OpenAPI */

  APIType type;
  List<APISchemaObject> allOf;
  List<APISchemaObject> anyOf;
  List<APISchemaObject> oneOf;
  APISchemaObject not;

  APISchemaObject items;
  Map<String, APISchemaObject> properties;
  APISchemaObject additionalProperties;

  String description;
  String format;
  dynamic defaultValue;

  bool get isNullable => _nullable ?? false;
  set isNullable(bool n) {
    _nullable = n;
  }

  // APIDiscriminator discriminator;
  bool get isReadOnly => _readOnly ?? false;
  set isReadOnly(bool n) {
    _readOnly = n;
  }

  bool get isWriteOnly => _writeOnly ?? false;
  set isWriteOnly(bool n) {
    _writeOnly = n;
  }

  bool get isDeprecated => _deprecated ?? false;
  set isDeprecated(bool n) {
    _deprecated = n;
  }

  bool _nullable;
  bool _readOnly;
  bool _writeOnly;
  bool _deprecated;

  void decode(JSONObject object) {
    super.decode(object);

    title = object.decode("title");
    maximum = object.decode("maximum");
    exclusiveMaximum = object.decode("exclusiveMaximum");
    minimum = object.decode("minimum");
    exclusiveMinimum = object.decode("exclusiveMinimum");
    maxLength = object.decode("maxLength");
    minLength = object.decode("minLength");
    pattern = object.decode("pattern");
    maxItems = object.decode("maxItems");
    minItems = object.decode("minItems");
    uniqueItems = object.decode("uniqueItems");
    multipleOf = object.decode("multipleOf");
    enumerated = object.decode("enum");
    minProperties = object.decode("minProperties");
    maxProperties = object.decode("maxProperties");
    required = object.decode("required");

    //

    type = APITypeCodec.decode(object.decode("type"));
    allOf = object.decodeObjects("allOf", () => new APISchemaObject());
    anyOf = object.decodeObjects("anyOf", () => new APISchemaObject());
    oneOf = object.decodeObjects("oneOf", () => new APISchemaObject());
    not = object.decode("not", inflate: () => new APISchemaObject());

    items = object.decode("items", inflate: () => new APISchemaObject());
    properties =
        object.decodeObjectMap("properties", () => new APISchemaObject());
    additionalProperties = object.decode("additionalProperties",
        inflate: () => new APISchemaObject());

    description = object.decode("description");
    format = object.decode("format");
    defaultValue = object.decode("default");

    _nullable = object.decode("nullable");
    _readOnly = object.decode("readOnly");
    _writeOnly = object.decode("writeOnly");
    _deprecated = object.decode("deprecated");
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("title", title);
    object.encode("maximum", maximum);
    object.encode("exclusiveMaximum", exclusiveMaximum);
    object.encode("minimum", minimum);
    object.encode("exclusiveMinimum", exclusiveMinimum);
    object.encode("maxLength", maxLength);
    object.encode("minLength", minLength);
    object.encode("pattern", pattern);
    object.encode("maxItems", maxItems);
    object.encode("minItems", minItems);
    object.encode("uniqueItems", uniqueItems);
    object.encode("multipleOf", multipleOf);
    object.encode("enum", enumerated);
    object.encode("minProperties", minProperties);
    object.encode("maxProperties", maxProperties);
    object.encode("required", required);

    //

    object.encode("type", APITypeCodec.encode(type));
    object.encodeObjects("allOf", allOf);
    object.encodeObjects("anyOf", anyOf);
    object.encodeObjects("oneOf", oneOf);
    object.encodeObject("not", not);

    object.encodeObject("items", items);
    object.encodeObject("additionalProperties", additionalProperties);
    object.encodeObjectMap("properties", properties);

    object.encode("description", description);
    object.encode("format", format);
    object.encode("default", defaultValue);

    object.encode("nullable", _nullable);
    object.encode("readOnly", _readOnly);
    object.encode("writeOnly", _writeOnly);
    object.encode("deprecated", _deprecated);
  }
}
