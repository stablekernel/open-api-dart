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

  void decode(JSONObject object) {
    // todo (joeconwaystk): Hasn't been common enough to use time on implementing yet.
    if (object.containsKey(r"$ref")) {
      return;
    }

    super.decode(object);

    summary = object.decode("summary");
    description = object.decode("description");
    parameters = object.decodeObjects("parameters", () => new APIParameter());

    final methodNames = [
      "get",
      "put",
      "post",
      "delete",
      "options",
      "head",
      "patch",
      "trace"
    ];
    methodNames.forEach((methodName) {
      if (!object.containsKey(methodName)) {
        return;
      }
      operations[methodName] =
          object.decode(methodName, inflate: () => new APIOperation());
    });
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("summary", summary);
    object.encode("description", description);
    object.encodeObjects("parameters", parameters);

    operations.forEach((opName, op) {
      object.encodeObject(opName, op);
    });
  }
}
