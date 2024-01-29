import 'package:codable_forked/cast.dart' as cast;
import 'package:open_api_forked/src/object.dart';
import 'package:open_api_forked/src/v3/callback.dart';
import 'package:open_api_forked/src/v3/parameter.dart';
import 'package:open_api_forked/src/v3/request_body.dart';
import 'package:open_api_forked/src/v3/response.dart';
import 'package:open_api_forked/src/v3/security.dart';
import 'package:open_api_forked/src/v3/path.dart';
import 'package:open_api_forked/src/v3/document.dart';
import 'package:open_api_forked/src/v3/server.dart';

/// Describes a single API operation on a path.
class APIOperation extends APIObject {
  APIOperation.empty();

  APIOperation(this.id, this.responses,
      {this.tags,
      this.summary,
      this.description,
      this.parameters,
      this.security,
      this.requestBody,
      this.callbacks,
      bool? deprecated}) {
    isDeprecated = deprecated;
  }

  /// A list of tags for API documentation control.
  ///
  /// Tags can be used for logical grouping of operations by resources or any other qualifier.
  List<String>? tags;

  /// A short summary of what the operation does.
  String? summary;

  /// A verbose explanation of the operation behavior.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String? description;

  /// Unique string used to identify the operation.
  ///
  /// The id MUST be unique among all operations described in the API. Tools and libraries MAY use the operationId to uniquely identify an operation, therefore, it is RECOMMENDED to follow common programming naming conventions.
  String? id;

  /// A list of parameters that are applicable for this operation.
  ///
  /// If a parameter is already defined at the Path Item, the definition will override it but can never remove it. The list MUST NOT include duplicated parameters. A unique parameter is defined by a combination of a name and location. The list can use the Reference Object to link to parameters that are defined at the OpenAPI Object's components/parameters.
  List<APIParameter?>? parameters;

  /// A declaration of which security mechanisms can be used for this operation.
  ///
  /// The list of values includes alternative security requirement objects that can be used. Only one of the security requirement objects need to be satisfied to authorize a request. This definition overrides any declared top-level security. To remove a top-level security declaration, an empty array can be used.
  List<APISecurityRequirement?>? security;

  /// The request body applicable for this operation.
  ///
  /// The requestBody is only supported in HTTP methods where the HTTP 1.1 specification RFC7231 has explicitly defined semantics for request bodies. In other cases where the HTTP spec is vague, requestBody SHALL be ignored by consumers.
  APIRequestBody? requestBody;

  /// The list of possible responses as they are returned from executing this operation.
  ///
  /// REQUIRED.
  Map<String, APIResponse?>? responses;

  /// A map of possible out-of band callbacks related to the parent operation.
  ///
  /// The key is a unique identifier for the [APICallback]. Each value in the map is a [APICallback] that describes a request that may be initiated by the API provider and the expected responses. The key value used to identify the callback object is an expression, evaluated at runtime, that identifies a URL to use for the callback operation.
  Map<String, APICallback?>? callbacks;

  /// An alternative server array to service this operation.
  ///
  /// If an alternative server object is specified at the [APIPath] or [APIDocument] level, it will be overridden by this value.
  List<APIServerDescription?>? servers;

  /// Declares this operation to be deprecated.
  ///
  /// Consumers SHOULD refrain from usage of the declared operation. Default value is false.
  bool? get isDeprecated => _deprecated;

  set isDeprecated(bool? f) {
    _deprecated = f;
  }

  bool? _deprecated;

  /// Returns the parameter named [name] or null if it doesn't exist.
  APIParameter? parameterNamed(String name) =>
      parameters?.firstWhere((p) => p?.name == name, orElse: () => null);

  /// Adds [parameter] to [parameters].
  ///
  /// If [parameters] is null, invoking this method will set it to a list containing [parameter].
  /// Otherwise, [parameter] is added to [parameters].
  void addParameter(APIParameter parameter) {
    (parameters ??= []).add(parameter);
  }

  /// Adds [requirement] to [security].
  ///
  /// If [security] is null, invoking this method will set it to a list containing [requirement].
  /// Otherwise, [requirement] is added to [security].
  void addSecurityRequirement(APISecurityRequirement requirement) {
    (security ??= []).add(requirement);
  }

  /// Adds [response] to [responses], merging schemas if necessary.
  ///
  /// [response] will be added to [responses] for the key [statusCode].
  ///
  /// If a response already exists for this [statusCode], [response]'s content
  /// and headers are added to the list of possible content and headers for the existing response. Descriptions
  /// of each response are joined together. All headers are marked as optional..
  void addResponse(int statusCode, APIResponse response) {
    final responses = this.responses ??= {};

    final key = "$statusCode";

    final existingResponse = responses[key];
    if (existingResponse == null) {
      responses[key] = response;
      return;
    }

    existingResponse.description =
        "${existingResponse.description ?? ""}\n${response.description}";
    response.headers?.forEach((name, header) {
      existingResponse.addHeader(name, header);
    });
    response.content?.forEach((contentType, mediaType) {
      existingResponse.addContent(contentType, mediaType?.schema);
    });
  }

  @override
  Map<String, cast.Cast> get castMap => {"tags": cast.List(cast.String)};

  void decode(KeyedArchive object) {
    super.decode(object);

    tags = object.decode("tags");
    summary = object.decode("summary");
    description = object.decode("description");
    id = object.decode("operationId");
    parameters = object.decodeObjects("parameters", () => APIParameter.empty());
    requestBody =
        object.decodeObject("requestBody", () => APIRequestBody.empty());
    responses = object.decodeObjectMap("responses", () => APIResponse.empty());
    callbacks = object.decodeObjectMap("callbacks", () => APICallback());
    _deprecated = object.decode("deprecated");
    security =
        object.decodeObjects("security", () => APISecurityRequirement.empty());
    servers =
        object.decodeObjects("servers", () => APIServerDescription.empty());
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    if (responses == null) {
      throw ArgumentError(
          "Invalid specification. APIOperation must have non-null values for: 'responses'.");
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
    object.encodeObjects("security", security);
    object.encodeObjects("servers", servers);
  }
}
