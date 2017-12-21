import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/callback.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/security.dart';
import 'package:open_api/src/v3/request_body.dart';

/// Holds a set of reusable objects for different aspects of the OAS.
///
/// All objects defined within the components object will have no effect on the API unless they are explicitly referenced from properties outside the components object.
class APIComponents extends APIObject {
  /// An object to hold reusable [APISchemaObject].
  Map<String, APISchemaObject> schemas = {};

  /// An object to hold reusable [APIResponse].
  Map<String, APIResponse> responses = {};

  /// An object to hold reusable [APIParameter].
  Map<String, APIParameter> parameters = {};

  //Map<String, APIExample> examples = {};

  /// An object to hold reusable [APIRequestBody].
  Map<String, APIRequestBody> requestBodies = {};

  /// An object to hold reusable [APIHeader].
  Map<String, APIHeader> headers = {};

  /// An object to hold reusable [APISecurityScheme].
  Map<String, APISecurityScheme> securitySchemes = {};

  //Map<String, APILink> links = {};

  /// An object to hold reusable [APICallback].
  Map<String, APICallback> callbacks = {};

  void decode(JSONObject object) {
    super.decode(object);

    schemas = object.decodeObjectMap("schemas", () => new APISchemaObject());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    parameters = object.decodeObjectMap("parameters", () => new APIParameter());
//    examples = object.decodeObjectMap("examples", () => new APIExample());
    requestBodies =
        object.decodeObjectMap("requestBodies", () => new APIRequestBody());
    headers = object.decodeObjectMap("headers", () => new APIHeader());

    securitySchemes = object.decodeObjectMap(
        "securitySchemes", () => new APISecurityScheme());
//    links = object.decodeObjectMap("links", () => new APILink());
    callbacks = object.decodeObjectMap("callbacks", () => new APICallback());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encodeObjectMap("schemas", schemas);
    object.encodeObjectMap("responses", responses);
    object.encodeObjectMap("parameters", parameters);
//    object.encodeObjectMap("examples", examples);
    object.encodeObjectMap("requestBodies", requestBodies);
    object.encodeObjectMap("headers", headers);
    object.encodeObjectMap("securitySchemes", securitySchemes);
//    object.encodeObjectMap("links", links);
    object.encodeObjectMap("callbacks", callbacks);
  }
}
