import 'path.dart';
import 'security.dart';
import 'metadata.dart';
import 'util.dart';
import 'parameter.dart';
import 'response.dart';
import 'json_object.dart';
import 'dart:convert';
import 'schema.dart';

/// Represents an OpenAPI 2.0 specification.
class APIDocument extends APIObject with JSONObjectCache {
  /// Creates an empty specification.
  APIDocument();

  /// Creates a specification from JSON.
  APIDocument.fromJSON(String jsonString) {
    _root = JSON.decode(jsonString, reviver: (k, v) {
      if (v is Map) {
        return new JSONObject(v, this);
      }

      return v;
    });

    decode(_root);

    // Can release this once we're done, since it is just a duplicate structure to the one rooted by this instance.
    _root = null;
  }

  String version = "2.0";
  APIInfo info = new APIInfo();
  String host;
  String basePath;
  List<String> schemes;
  List<String> consumes = [];
  List<String> produces = [];
  Map<String, APIPath> paths = {};
  Map<String, APISchemaObject> definitions = {};
  Map<String, APIParameter> parameters = {};
  Map<String, APIResponse> responses = {};
  List<Map<String, List<String>>> security = [];
  Map<String, APISecurityScheme> securityDefinitions = {};
  List<APITag> tags = [];

  JSONObject get root => _root;
  JSONObject _root;

  Map<String, dynamic> asMap() {
    _root = new JSONObject({}, this);

    encode(_root);

    var m = _root;
    _root = null;
    return m.asMap();
  }

  void decode(JSONObject object) {
    version = object.decode("swagger");
    host = object.decode("host");
    basePath = object.decode("basePath");
    schemes = object.decode("schemes");
    consumes = object.decode("consumes");
    produces = object.decode("produces");
    security = object.decode("security");
    info = object.decode("info", inflate: () => new APIInfo());

    tags = object.decodeObjects("tags", () => new APITag());

    paths = object.decodeObjectMap("paths", () => new APIPath());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    parameters = object.decodeObjectMap("parameters", () => new APIParameter());
    definitions = object.decodeObjectMap("definitions", () => new APISchemaObject());
    securityDefinitions = object.decodeObjectMap("securityDefinitions", () => new APISecurityScheme());
  }

  void encode(JSONObject object) {
    object.encode("swagger", version);
    object.encode("host", host);
    object.encode("basePath", basePath);
    object.encode("schemes", schemes);
    object.encode("consumes", consumes);
    object.encode("produces", produces);
    object.encodeObjectMap("paths", paths);
    object.encodeObject("info", info);
    object.encodeObjectMap("parameters", parameters);
    object.encodeObjectMap("responses", responses);
    object.encodeObjectMap("securityDefinitions", securityDefinitions);
    object.encode("security", security);
    object.encodeObjects("tags", tags);
    object.encodeObjectMap("definitions", definitions);
  }
}

