import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/media_type.dart';

class APICallback extends APIObject {
  String description;
  Map<String, APIMediaType> content;
  bool isRequired = false;

  void decode(JSONObject json) {
    description = json.decode("description");
    isRequired = json.decode("required") ?? false;
  }

  void encode(JSONObject json) {
    json.encode("description", description);
    json.encode("required", isRequired);
  }
}
