import 'parameter.dart';
import 'util.dart';
import 'operation.dart';
import 'json_object.dart';

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath extends APIObject {
  APIPath();

  List<APIParameter> parameters = [];
  Map<String, APIOperation> operations = {};

  void decode(JSONObject json) {
    json.keys.forEach((k) {
      if (k == r"$ref") {
        // todo: reference
      } else if (k == "parameters") {
        parameters = json.decodeObjects(k, () => new APIParameter());
      } else {
        operations[k] = json.decode(k, inflate: () => new APIOperation());
      }
    });
  }

  void encode(JSONObject json) {
    json.encodeObjects("parameters", parameters);
    operations.forEach((opName, op) {
      json.encodeObject(opName, op);
    });
  }
}