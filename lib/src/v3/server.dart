import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';

class APIServerDescription extends APIObject {
  String url;
  String description;
  Map<String, APIServerVariable> variables;

  void decode(JSONObject json) {
    url = json.decode("url");
    description = json.decode("description");
    variables = json.decodeObjectMap("variables", () => new APIServerVariable());
  }

  void encode(JSONObject json) {
    json.encode("url", url);
    json.encode("description", description);
    json.encodeObjectMap("variables", variables);
  }
}

class APIServerVariable extends APIObject {
  List<String> availableValues;
  String defaultValue;
  String description;

  void decode(JSONObject json) {
    availableValues = json.decode("enum");
    defaultValue = json.decode("default");
    description = json.decode("description");
  }

  void encode(JSONObject json) {
    json.encode("enum", availableValues);
    json.encode("default", defaultValue);
    json.encode("description", description);
  }
}