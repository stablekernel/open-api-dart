import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/property.dart';
import 'package:open_api/src/v3/types.dart';
import 'package:open_api/src/util.dart';

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, cookie }

class APIParameterLocationCodec {
  static APIParameterLocation decode(String location) {
    switch (location) {
      case "query": return APIParameterLocation.query;
      case "header": return APIParameterLocation.header;
      case "path": return APIParameterLocation.path;
      case "cookie": return APIParameterLocation.cookie;
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
      case APIParameterLocation.cookie:
        return "cookie";
    }
    return null;
  }
}

/// Represents a parameter in the OpenAPI specification.
class APIParameter extends APIObject {
  APIParameter();

  String name;
  String description;
  bool isRequired = false;
  bool isDeprecated = false;
  APIParameterLocation location;
  APISchemaObject schema;

  // Valid if location is query, e.g. /?bool
  bool allowEmptyValue;

  // Currently missing:
  // style, explode, allowReserved, example, examples, content

  void decode(JSONObject json) {
    name = json.decode("name");
    description = json.decode("description");
    location = APIParameterLocationCodec.decode(json.decode("in"));
    if (location == APIParameterLocation.path) {
      isRequired = true;
    } else {
      isRequired = json.decode("required") ?? false;
    }

    isDeprecated = json.decode("deprecated") ?? false;
    if (location == APIParameterLocation.query) {
      allowEmptyValue = json.decode("allowEmptyValue") ?? false;
    }

    schema = json.decode("schema", inflate: () => new APISchemaObject());
  }

  void encode(JSONObject json) {
    json.encode("name", name);
    json.encode("description", description);
    json.encode("in", APIParameterLocationCodec.encode(location));
    json.encode("required", isRequired);
    json.encode("deprecated", isDeprecated);

    if (location == APIParameterLocation.query) {
      json.encode("allowEmptyValue", allowEmptyValue);
    }

    json.encodeObject("schema", schema);
  }
}
