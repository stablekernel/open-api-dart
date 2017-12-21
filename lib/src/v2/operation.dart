import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v2/parameter.dart';
import 'package:open_api/src/v2/response.dart';
import 'package:open_api/src/util.dart';

/// Represents a HTTP operation (a path/method pair) in the OpenAPI specification.
class APIOperation extends APIObject {
  APIOperation();

  String summary = "";
  String description = "";
  String id;
  bool deprecated = false;

  List<String> tags = [];
  List<String> schemes = [];
  List<String> consumes = [];
  List<String> produces = [];
  List<APIParameter> parameters = [];
  List<Map<String, List<String>>> security = [];
  Map<String, APIResponse> responses = {};

  void decode(JSONObject object) {
    super.decode(object);

    tags = object.decode("tags");
    summary = object.decode("summary");
    description = object.decode("description");
    id = object.decode("operationId");
    consumes = object.decode("consumes");
    produces = object.decode("produces");
    deprecated = object.decode("deprecated") ?? false;
    parameters = object.decodeObjects("parameters", () => new APIParameter());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    schemes = object.decode("schemes");
    security = object.decode("security");
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("tags", tags);
    object.encode("summary", summary);
    object.encode("description", description);
    object.encode("operationId", id);
    object.encode("consumes", consumes);
    object.encode("produces", produces);
    object.encode("deprecated", deprecated);

    object.encodeObjects("parameters", parameters);
    object.encodeObjectMap("responses", responses);
    object.encode("security", security);
  }
}
