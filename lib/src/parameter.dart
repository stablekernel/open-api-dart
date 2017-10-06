import 'json_object.dart';
import 'schema.dart';
import 'util.dart';
import 'types.dart';

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, formData, body }

class APIParameterLocationCodec {
  static APIParameterLocation decode(String location) {
    switch (location) {
      case "query": return APIParameterLocation.query;
      case "header": return APIParameterLocation.header;
      case "path": return APIParameterLocation.path;
      case "formData": return APIParameterLocation.formData;
      case "body": return APIParameterLocation.body;
    }

    return null;
  }

  static String encode(APIParameterLocation location) {
    switch (location) {
      case APIParameterLocation.query:
        return "query";
      case APIParameterLocation.header:
        return "header";
      case APIParameterLocation.path:
        return "path";
      case APIParameterLocation.formData:
        return "formData";
      case APIParameterLocation.body:
        return "body";
    }
    return null;
  }
}

/// Represents a parameter in the OpenAPI specification.
class APIParameter implements APIObject {
  APIParameter();

  APIParameter.fromJSON(JSONObject json) {
    // todo: reference

    name = json.decode("name");
    location = APIParameterLocationCodec.decode(json.decode("in"));
    description = json.decode("description");

    if (location == APIParameterLocation.path) {
      required = true;
    } else {
      required = json.decode("required") ?? false;
    }

    if (location == APIParameterLocation.body) {
      schema = json.decode("schema", objectDecoder: (v) => new APISchemaObject.fromJSON(v));
    } else {
      type = APITypeCodec.decode(json.decode("type"));
      format = json.decode("format");
      allowEmptyValue = json.decode("allowEmptyValue") ?? false;
    }
  }

  String name;
  String description = "";
  bool required = false;
  APIParameterLocation location;

  // Valid if location is body.
  APISchemaObject schema;

  // Valid if location is not body.
  APIType type;
  String format;
  bool allowEmptyValue = false;

//  List<APIItem> items;
//  String collectionFormat = "csv";
//  dynamic defaultValue;
//  num maximum;
//  bool exclusiveMaximum;
//  num minimum;
//  bool exclusiveMinimum;
//  int maxLength;
//  int minLength;
//  String pattern;
//  int maxItems;
//  int minItems;
//  bool uniqueItems;
//  num multipleOf;

  void encodeInto(JSONObject json) {
    json.encode("name", name);
    json.encode("description", description);

    json.encode("in", APIParameterLocationCodec.encode(location));

    if (location == APIParameterLocation.body) {
      json.encodeObject("schema", schema);
    } else {
      json.encode("type", APITypeCodec.encode(type));
      json.encode("format", format);
      json.encode("allowEmptyValue", allowEmptyValue);
    }
  }
}
