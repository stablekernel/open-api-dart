import 'types.dart';
import 'json_object.dart';
import 'property.dart';

/// Represents a header in the OpenAPI specification.
class APIHeader extends APIProperty {
  APIHeader();

  String description;
  APIProperty items;

  void decode(JSONObject json) {
    super.decode(json);
    description = json.decode("description");
    if (type == APIType.array) {
      items = json.decode("items", inflate: () => new APIProperty());
    }
  }

  void encode(JSONObject json) {
    super.encode(json);
    json.encode("description", description);
    if (type == APIType.array) {
      json.encodeObject("items", items);
    }
  }
}
