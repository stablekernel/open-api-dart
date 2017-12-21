import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/callback.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/request_body.dart';
import 'package:open_api/src/util.dart';

/// Describes a single API operation on a path.
class APIOperation extends APIObject {
  APIOperation();

  /// A list of tags for API documentation control.
  ///
  /// Tags can be used for logical grouping of operations by resources or any other qualifier.
  List<String> tags = [];

  /// A short summary of what the operation does.
  String summary;

  /// A verbose explanation of the operation behavior.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  /// Unique string used to identify the operation.
  ///
  /// The id MUST be unique among all operations described in the API. Tools and libraries MAY use the operationId to uniquely identify an operation, therefore, it is RECOMMENDED to follow common programming naming conventions.
  String id;

  /// A list of parameters that are applicable for this operation.
  ///
  /// If a parameter is already defined at the Path Item, the new definition will override it but can never remove it. The list MUST NOT include duplicated parameters. A unique parameter is defined by a combination of a name and location. The list can use the Reference Object to link to parameters that are defined at the OpenAPI Object's components/parameters.
  List<APIParameter> parameters = [];

  /// A declaration of which security mechanisms can be used for this operation.
  ///
  /// The list of values includes alternative security requirement objects that can be used. Only one of the security requirement objects need to be satisfied to authorize a request. This definition overrides any declared top-level security. To remove a top-level security declaration, an empty array can be used.
  List<Map<String, List<String>>> security = [];

  /// The request body applicable for this operation.
  ///
  /// The requestBody is only supported in HTTP methods where the HTTP 1.1 specification RFC7231 has explicitly defined semantics for request bodies. In other cases where the HTTP spec is vague, requestBody SHALL be ignored by consumers.
  APIRequestBody requestBody = new APIRequestBody();

  /// The list of possible responses as they are returned from executing this operation.
  ///
  /// REQUIRED.
  Map<String, APIResponse> responses = {};

  /// A map of possible out-of band callbacks related to the parent operation.
  ///
  /// The key is a unique identifier for the [APICallback]. Each value in the map is a [APICallback] that describes a request that may be initiated by the API provider and the expected responses. The key value used to identify the callback object is an expression, evaluated at runtime, that identifies a URL to use for the callback operation.
  Map<String, APICallback> callbacks = {};

  /// Declares this operation to be deprecated.
  ///
  /// Consumers SHOULD refrain from usage of the declared operation. Default value is false.
  bool get isDeprecated => _deprecated ?? false;

  set isDeprecated(bool f) {
    _deprecated = f;
  }

  bool _deprecated = false;

  void decode(JSONObject object) {
    super.decode(object);

    tags = object.decode("tags");
    summary = object.decode("summary");
    description = object.decode("description");
    id = object.decode("operationId");
    parameters = object.decodeObjects("parameters", () => new APIParameter());
    requestBody = object.decode("requestBody", inflate: () => new APIRequestBody());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    callbacks = object.decodeObjectMap("callbacks", () => new APICallback());
    _deprecated = object.decode("deprecated");
    security = object.decode("security");
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (responses == null) {
      throw new APIException("APIOperation must have non-null values for: 'responses'.");
    }

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
