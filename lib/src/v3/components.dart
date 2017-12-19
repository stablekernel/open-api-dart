import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/response.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/security.dart';
import 'package:open_api/src/v3/request_body.dart';

class APIComponents extends APIObject {
  Map<String, APISchemaObject> schemas = {};
  Map<String, APIResponse> responses = {};
  Map<String, APIParameter> parameters = {};
  //Map<String, APIExample> examples = {};

  Map<String, APIRequestBody> requestBodies= {};
  Map<String, APIHeader> headers = {};
  Map<String, APISecurityScheme> securitySchemes = {};
  //Map<String, APILink> links = {};
  //Map<String, APICallback> callbacks = {};

  void decode(JSONObject object) {
    schemas = object.decodeObjectMap("schemas", () => new APISchemaObject());
    responses = object.decodeObjectMap("responses", () => new APIResponse());
    parameters = object.decodeObjectMap("parameters", () => new APIParameter());
//    examples = object.decodeObjectMap("examples", () => new APIExample());
    requestBodies = object.decodeObjectMap("requestBodies", () => new APIRequestBody());
    headers = object.decodeObjectMap("headers", () => new APIHeader());

    securitySchemes = object.decodeObjectMap("securitySchemes", () => new APISecurityScheme());
//    links = object.decodeObjectMap("links", () => new APILink());
//    callbacks = object.decodeObjectMap("callbacks", () => new APICallback());
  }

  void encode(JSONObject object) {
    object.encodeObjectMap("schemas", schemas);
    object.encodeObjectMap("responses", responses);
    object.encodeObjectMap("parameters", parameters);
//    object.encodeObjectMap("examples", examples);
    object.encodeObjectMap("requestBodies", requestBodies);
    object.encodeObjectMap("headers", headers);
    object.encodeObjectMap("securitySchemes", securitySchemes);
//    object.encodeObjectMap("links", links);
//    object.encodeObjectMap("callbacks", callbacks);
  }
}