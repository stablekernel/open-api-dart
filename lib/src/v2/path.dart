import 'package:open_api_forked/src/object.dart';
import 'package:open_api_forked/src/v2/operation.dart';
import 'package:open_api_forked/src/v2/parameter.dart';

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath extends APIObject {
  APIPath();

  List<APIParameter?> parameters = [];
  Map<String, APIOperation?> operations = {};

  void decode(KeyedArchive object) {
    super.decode(object);

    object.keys.forEach((k) {
      if (k == r"$ref") {
        // todo: reference
      } else if (k == "parameters") {
        parameters = object.decodeObjects(k, () => APIParameter())!;
      } else {
        operations[k] = object.decodeObject(k, () => APIOperation());
      }
    });
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encodeObjects("parameters", parameters);
    operations.forEach((opName, op) {
      object.encodeObject(opName, op);
    });
  }
}
