import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/media_type.dart';

class APIRequestBody extends APIObject {
  String description;
  Map<String, APIMediaType> content;
  bool get isRequired => _required ?? false;
  set isRequired(bool f) {
    _required = f;
  }

  bool _required;

  void decode(JSONObject object) {
    super.decode(object);

    description = object.decode("description");
    _required = object.decode("required");
    content = object.decodeObjectMap("content", () => new APIMediaType());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("description", description);
    object.encode("required", _required);
    object.encodeObjectMap("content", content);
  }
}
