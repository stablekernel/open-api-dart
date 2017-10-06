import 'parameter.dart';
import 'util.dart';
import 'operation.dart';
import 'json_object.dart';

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath extends APIObject {
  APIPath();

  APIPath.fromJSON(JSONObject json) {
    json.keys.forEach((k) {
      if (k == r"$ref") {
      // todo: reference
      } else if (k == "parameters") {
        parameters = json.decodeObjects(k, (object) => new APIParameter.fromJSON(object));
      } else {
        operations[k] = json.decode(k, objectDecoder: (object) => new APIOperation.fromJSON(object));
      }
    });
  }

  List<APIParameter> parameters = [];
  Map<String, APIOperation> operations = {};

  void encodeInto(JSONObject json) {
    json.encodeObjects("parameters", parameters);
    operations.forEach((opName, op) {
      json.encodeObject(opName, op);
    });
  }
}