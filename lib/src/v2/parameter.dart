import 'package:codable/codable.dart';
import 'package:open_api/src/v2/property.dart';
import 'package:open_api/src/v2/schema.dart';
import 'package:open_api/src/v2/types.dart';

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, formData, body }

class APIParameterLocationCodec {
  static APIParameterLocation decode(String location) {
    switch (location) {
      case "query":
        return APIParameterLocation.query;
      case "header":
        return APIParameterLocation.header;
      case "path":
        return APIParameterLocation.path;
      case "formData":
        return APIParameterLocation.formData;
      case "body":
        return APIParameterLocation.body;
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
class APIParameter extends APIProperty {
  APIParameter();

  String name;
  String description;
  bool required = false;
  APIParameterLocation location;

  // Valid if location is body.
  APISchemaObject schema;

  // Valid if location is not body.
  bool allowEmptyValue = false;
  APIProperty items;

  void decode(KeyedArchive json) {
    name = json.decode("name");
    description = json.decode("description");
    location = APIParameterLocationCodec.decode(json.decode("in"));
    if (location == APIParameterLocation.path) {
      required = true;
    } else {
      required = json.decode("required") ?? false;
    }

    if (location == APIParameterLocation.body) {
      schema = json.decodeObject("schema", () => new APISchemaObject());
    } else {
      super.decode(json);
      allowEmptyValue = json.decode("allowEmptyValue") ?? false;
      if (type == APIType.array) {
        items = json.decodeObject("items", () => new APIProperty());
      }
    }
  }

  void encode(KeyedArchive json) {
    json.encode("name", name);
    json.encode("description", description);
    json.encode("in", APIParameterLocationCodec.encode(location));
    json.encode("required", required);

    if (location == APIParameterLocation.body) {
      json.encodeObject("schema", schema);
    } else {
      super.encode(json);
      json.encode("allowEmptyValue", allowEmptyValue);
      if (type == APIType.array) {
        json.encodeObject("items", items);
      }
    }
  }
}
