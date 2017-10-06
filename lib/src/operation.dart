import 'json_object.dart';
import 'parameter.dart';
import 'response.dart';
import 'util.dart';

/// Represents a HTTP operation (a path/method pair) in the OpenAPI specification.
class APIOperation extends APIObject {
  APIOperation();

  APIOperation.fromJSON(JSONObject json) {
    tags = json.decode("tags");
    summary = json.decode("summary");
    description = json.decode("description");
    id = json.decode("operationId");
    consumes = json.decode("consumes");
    produces = json.decode("produces");
    deprecated = json.decode("deprecated") ?? false;

    parameters = json.decodeObjects("parameters", (v) => new APIParameter.fromJSON(v));

    responses = json.decodeObjectMap("responses", (v) => new APIResponse.fromJSON(v));
    schemes = json.decode("schemes");
    security = json.decode("security");
  }

  String method;

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

  void encodeInto(JSONObject json) {
    json.encode("tags", tags);
    json.encode("summary", summary);
    json.encode("description", description);
    json.encode("operationId", id);
    json.encode("consumes", consumes);
    json.encode("produces", produces);
    json.encode("deprecated", deprecated);

    json.encodeObjects("parameters", parameters);
    json.encodeObjectMap("responses", responses);
    json.encode("security", security);
  }
}
