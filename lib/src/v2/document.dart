import 'package:codable/cast.dart' as cast;
import 'package:open_api/src/object.dart';
import 'package:open_api/src/v2/metadata.dart';
import 'package:open_api/src/v2/parameter.dart';
import 'package:open_api/src/v2/path.dart';
import 'package:open_api/src/v2/response.dart';
import 'package:open_api/src/v2/schema.dart';
import 'package:open_api/src/v2/security.dart';

/// Represents an OpenAPI 2.0 specification.
class APIDocument extends APIObject {
  /// Creates an empty specification.
  APIDocument();

  /// Creates a specification from decoded JSON or YAML document object.
  APIDocument.fromMap(Map<String, dynamic> map) {
    decode(KeyedArchive.unarchive(map, allowReferences: true));
  }

  String version = "2.0";
  APIInfo info = new APIInfo();
  String host;
  String basePath;

  List<APITag> tags = [];
  List<String> schemes = [];
  List<String> consumes = [];
  List<String> produces = [];
  List<Map<String, List<String>>> security = [];

  Map<String, APIPath> paths = {};
  Map<String, APIResponse> responses = {};
  Map<String, APIParameter> parameters = {};
  Map<String, APISchemaObject> definitions = {};
  Map<String, APISecurityScheme> securityDefinitions = {};

  Map<String, dynamic> asMap() {
    return KeyedArchive.archive(this, allowReferences: true);
  }

  @override
  Map<String, cast.Cast> get castMap => {
        "schemes": cast.List(cast.String),
        "consumes": cast.List(cast.String),
        "produces": cast.List(cast.String),
        "security": cast.List(cast.Map(cast.String, cast.List(cast.String)))
      };

  void decode(KeyedArchive object) {
    super.decode(object);

    version = object["swagger"];
    host = object["host"];
    basePath = object["basePath"];
    schemes = object["schemes"];
    consumes = object["consumes"];
    produces = object["produces"];
    security = object["security"];

    info = object.decodeObject("info", () => new APIInfo());
    tags = object.decodeObjects("tags", () => new APITag());
    paths = object.decodeObjectMap("paths", () => new APIPath());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    parameters = object.decodeObjectMap("parameters", () => new APIParameter());
    definitions = object.decodeObjectMap("definitions", () => new APISchemaObject());
    securityDefinitions = object.decodeObjectMap("securityDefinitions", () => new APISecurityScheme());
  }

  void encode(KeyedArchive object) {
    super.encode(object);

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
