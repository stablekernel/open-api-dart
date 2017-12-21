import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/callback.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/request_body.dart';
import 'package:open_api/src/util.dart';

/// Represents a HTTP operation (a path/method pair) in the OpenAPI specification.
class APIOperation extends APIObject {
  APIOperation();

  List<String> tags = [];
  String summary;
  String description;
  String id;
  List<APIParameter> parameters = [];
  APIRequestBody requestBody = new APIRequestBody();
  Map<String, APIResponse> responses = {};

  Map<String, APICallback> callbacks = {};
  bool get isDeprecated => _deprecated ?? false;

  set isDeprecated(bool f) {
    _deprecated = f;
  }

  bool _deprecated = false;
  List<Map<String, List<String>>> security = [];

  void decode(JSONObject object) {
    super.decode(object);

    tags = object.decode("tags");
    summary = object.decode("summary");
    description = object.decode("description");
    id = object.decode("operationId");
    parameters = object.decodeObjects("parameters", () => new APIParameter());
    requestBody =
        object.decode("requestBody", inflate: () => new APIRequestBody());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    callbacks = object.decodeObjectMap("callbacks", () => new APICallback());
    _deprecated = object.decode("deprecated");
    security = object.decode("security");
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("tags", tags);
    object.encode("summary", summary);
    object.encode("description", description);
    object.encode("operationId", id);
    object.encodeObjects("parameters", parameters);
    object.encodeObject("requestBody", requestBody);
    object.encodeObjectMap("responses", responses);
    object.encodeObjectMap("callbacks", callbacks);
    object.encode("deprecated", _deprecated);
    object.encode("security", security);
  }
}
