import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/operation.dart';
import 'package:open_api/src/v3/parameter.dart';

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath extends APIObject {
  APIPath();

  String summary;
  String description;
  List<APIParameter> parameters = [];
  Map<String, APIOperation> operations = {};

  // todo (joeconwaystk): alternative servers not yet implemented

  void decode(JSONObject json) {
    // todo (joeconwaystk): Hasn't been common enough to use time on implementing yet.
    if (json.containsKey(r"$ref")) {
      return;
    }

    summary = json.decode("summary");
    description = json.decode("description");
    parameters = json.decodeObjects("parameters", () => new APIParameter());

    final methodNames = ["get", "put", "post", "delete", "options", "head", "patch", "trace"];
    methodNames.forEach((methodName) {
      if (!json.containsKey(methodName)) {
        return;
      }
      operations[methodName] = json.decode(methodName, inflate: () => new APIOperation());
    });

  }

  void encode(JSONObject json) {
    json.encode("summary", summary);
    json.encode("description", description);
    json.encodeObjects("parameters", parameters);

    operations.forEach((opName, op) {
      json.encodeObject(opName, op);
    });
  }
}