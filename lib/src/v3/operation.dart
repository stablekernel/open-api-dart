import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/request_body.dart';
import 'package:open_api/src/util.dart';

/// Represents a HTTP operation (a path/method pair) in the OpenAPI specification.
class APIOperation extends APIObject {
  APIOperation();

  List<String> tags = [];
  String summary = "";
  String description = "";
  String id;
  List<APIParameter> parameters = [];
  APIRequestBody requestBody = new APIRequestBody();
  Map<String, APIResponse> responses = {};
//  Map<String, APICallback> callbacks = {};
  bool deprecated = false;
  List<Map<String, List<String>>> security = [];

  void decode(JSONObject json) {
    tags = json.decode("tags");
    summary = json.decode("summary");
    description = json.decode("description");
    id = json.decode("operationId");
    parameters = json.decodeObjects("parameters", () => new APIParameter());
    requestBody = json.decode("requestBody", inflate: () => new APIRequestBody());
    responses = json.decodeObjectMap("responses", () => new APIResponse());
//    callbacks = json.decodeObjectMap("callbacks", () => new APICallback());
    deprecated = json.decode("deprecated") ?? false;
    security = json.decode("security");
  }

  void encode(JSONObject json) {
    json.encode("tags", tags);
    json.encode("summary", summary);
    json.encode("description", description);
    json.encode("operationId", id);
    json.encodeObjects("parameters", parameters);
    json.encodeObject("requestBody", requestBody);
    json.encodeObjectMap("responses", responses);
//    json.encodeObjectMap("callbacks", callbacks);
    json.encode("deprecated", deprecated);
    json.encode("security", security);
  }
}
