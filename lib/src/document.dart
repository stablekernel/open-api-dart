import 'path.dart';
import 'security.dart';
import 'metadata.dart';
import 'util.dart';
import 'parameter.dart';
import 'schema.dart';
import 'response.dart';
import 'json_object.dart';

/// Represents an OpenAPI 2.0 specification.
class APIDocument implements APIObject {
  /// Creates an empty specification.
  APIDocument();

  /// Creates a specification from JSON.
  APIDocument.fromJSON(Map<String, dynamic> map) {
    var json = new JSONObject(map);

    version = json.decode("swagger");
    info = json.decode("info", objectDecoder: (v) => new APIInfo.fromJSON(v));
    host = json.decode("host");
    basePath = json.decode("basePath");
    schemes = json.decode("schemes");
    consumes = json.decode("consumes");
    produces = json.decode("produces");

    definitions = json.decode("definitions");
    paths = json.decodeObjectMap("paths", (v) => new APIPath.fromJSON(v));
    parameters = json.decodeObjectMap("parameters", (v) => new APIParameter.fromJSON(v));
    responses = json.decodeObjectMap("responses", (v) => new APIResponse.fromJSON(v));
    securityDefinitions = json.decodeObjectMap("securityDefinitions", (v) => new APISecurityScheme.fromJSON(v));
    security = json.decode("security");
    tags = json.decodeObjects("tags", (v) => new APITag.fromJSON(v));
  }

  String version = "2.0";
  APIInfo info = new APIInfo();
  String host;
  String basePath;
  List<String> schemes;
  List<String> consumes = [];
  List<String> produces = [];
  Map<String, APIPath> paths = {};
  Map<String, dynamic> definitions = {};
  Map<String, APIParameter> parameters = {};
  Map<String, APIResponse> responses = {};
  List<Map<String, List<String>>> security = [];
  Map<String, APISecurityScheme> securityDefinitions = {};
  List<APITag> tags = [];

  Map<String, dynamic> asMap() {
    var m = new JSONObject({});

    encodeInto(m);

    return m.asMap();
  }

  void encodeInto(JSONObject object) {
    object.encode("swagger", version);
    object.encode("host", host);
    object.encode("basePath", basePath);
    object.encode("schemes", schemes);
    object.encode("consumes", consumes);
    object.encode("produces", produces);
    object.encodeObjectMap("paths", paths);
    object.encodeObject("info", info);
    object.encode("definitions", definitions);
    object.encodeObjectMap("parameters", parameters);
    object.encodeObjectMap("responses", responses);
    object.encodeObjectMap("securityDefinitions", securityDefinitions);
    object.encode("security", security);
    object.encodeObjects("tags", tags);
  }
}

