import 'package:open_api/src/object.dart';
import 'package:open_api/src/v3/callback.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/request_body.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/security.dart';

/// Holds a set of reusable objects for different aspects of the OAS.
///
/// All objects defined within the components object will have no effect on the API unless they are explicitly referenced from properties outside the components object.
class APIComponents extends APIObject {
  APIComponents();

  APIComponents.empty();

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

  /// Returns a component definition for [uri].
  ///
  /// Construct [uri] as a path, e.g. `Uri(path: /components/schemas/name)`.
  APIObject resolveUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length != 3) {
      throw new ArgumentError("Invalid reference URI. Must be a path URI of the form: '/components/<type>/<name>'");
    }

    if (segments.first != "components") {
      throw new ArgumentError("Invalid reference URI: does not begin with /components/");
    }

    var namedMap = null;
    switch (segments[1]) {
      case "schemas": namedMap = schemas; break;
      case "responses": namedMap = responses; break;
      case "parameters": namedMap = parameters; break;
      case "requestBodies": namedMap = requestBodies; break;
      case "headers": namedMap = headers; break;
      case "securitySchemes": namedMap = securitySchemes; break;
      case "callbacks": namedMap = callbacks; break;
    }

    if (namedMap == null) {
      throw new ArgumentError("Invalid reference URI: component type '${segments[1]}' does not exist.");
    }

    return namedMap[segments.last];
  }

  T resolve<T extends APIObject>(T refObject) {
    if (refObject.referenceURI == null) {
      throw new ArgumentError("APIObject is not a reference to a component.");
    }

    return resolveUri(refObject.referenceURI);
  }

  void decode(KeyedArchive object) {
    super.decode(object);

    schemas = object.decodeObjectMap("schemas", () => new APISchemaObject());
    responses = object.decodeObjectMap("responses", () => new APIResponse.empty());
    parameters = object.decodeObjectMap("parameters", () => new APIParameter.empty());
//    examples = object.decodeObjectMap("examples", () => new APIExample());
    requestBodies =
        object.decodeObjectMap("requestBodies", () => new APIRequestBody.empty());
    headers = object.decodeObjectMap("headers", () => new APIHeader());

    securitySchemes = object.decodeObjectMap(
        "securitySchemes", () => new APISecurityScheme());
//    links = object.decodeObjectMap("links", () => new APILink());
    callbacks = object.decodeObjectMap("callbacks", () => new APICallback());
  }

  void encode(KeyedArchive object) {
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
