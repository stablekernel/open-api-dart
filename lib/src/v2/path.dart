import 'package:open_api/src/v2/parameter.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v2/operation.dart';
import 'package:open_api/src/json_object.dart';

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath extends APIObject {
  APIPath();

  List<APIParameter> parameters = [];
  Map<String, APIOperation> operations = {};

  void decode(JSONObject object) {
    super.decode(object);

    object.keys.forEach((k) {
      if (k == r"$ref") {
        // todo: reference
      } else if (k == "parameters") {
        parameters = object.decodeObjects(k, () => new APIParameter());
      } else {
        operations[k] = object.decodeObject(k, () => new APIOperation());
      }
    });
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encodeObjects("parameters", parameters);
    operations.forEach((opName, op) {
      object.encodeObject(opName, op);
    });
  }
}
