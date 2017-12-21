import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/util.dart';

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, cookie }

class APIParameterLocationCodec {
  static APIParameterLocation decode(String location) {
    switch (location) {
      case "query":
        return APIParameterLocation.query;
      case "header":
        return APIParameterLocation.header;
      case "path":
        return APIParameterLocation.path;
      case "cookie":
        return APIParameterLocation.cookie;
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
  bool get isRequired =>
      (location == APIParameterLocation.path ? true : (_required ?? false));
  set isRequired(bool f) {
    _required = f;
  }

  bool _required;

  bool get isDeprecated => _deprecated ?? false;
  set isDeprecated(bool f) {
    _deprecated = f;
  }

  bool _deprecated;
  APIParameterLocation location;
  APISchemaObject schema;

  // Valid if location is query, e.g. /?bool
  bool get allowEmptyValue => _allowEmptyValue ?? false;
  set allowEmptyValue(bool f) {
    _allowEmptyValue = f;
  }

  bool _allowEmptyValue;

  // Currently missing:
  // style, explode, allowReserved, example, examples, content

  void decode(JSONObject object) {
    super.decode(object);

    name = object.decode("name");
    description = object.decode("description");
    location = APIParameterLocationCodec.decode(object.decode("in"));
    _required = object.decode("required");

    _deprecated = object.decode("deprecated");
    _allowEmptyValue = object.decode("allowEmptyValue");

    schema = object.decode("schema", inflate: () => new APISchemaObject());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("name", name);
    object.encode("description", description);
    object.encode("in", APIParameterLocationCodec.encode(location));

    if (location == APIParameterLocation.path) {
      object.encode("required", true);
    } else {
      object.encode("required", _required);
    }

    object.encode("deprecated", _deprecated);

    if (location == APIParameterLocation.query) {
      object.encode("allowEmptyValue", _allowEmptyValue);
    }

    object.encodeObject("schema", schema);
  }
}
