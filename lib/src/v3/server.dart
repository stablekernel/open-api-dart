import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';

class APIServerDescription extends APIObject {
  String url;
  String description;
  Map<String, APIServerVariable> variables = {};

  void decode(JSONObject object) {
    super.decode(object);

    url = object.decode("url");
    description = object.decode("description");
    variables =
        object.decodeObjectMap("variables", () => new APIServerVariable());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("url", url);
    object.encode("description", description);
    object.encodeObjectMap("variables", variables);
  }
}

class APIServerVariable extends APIObject {
  List<String> availableValues;
  String defaultValue;
  String description;

  void decode(JSONObject object) {
    super.decode(object);

    availableValues = object.decode("enum");
    defaultValue = object.decode("default");
    description = object.decode("description");
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("enum", availableValues);
    object.encode("default", defaultValue);
    object.encode("description", description);
  }
}
