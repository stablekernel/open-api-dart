import 'package:codable/codable.dart';
import 'package:open_api/src/v2/property.dart';
import 'package:open_api/src/v2/types.dart';

/// Represents a header in the OpenAPI specification.
class APIHeader extends APIProperty {
  APIHeader();

  String description;
  APIProperty items;

  void decode(KeyedArchive json) {
    super.decode(json);
    description = json.decode("description");
    if (type == APIType.array) {
      items = json.decodeObject("items", () => new APIProperty());
    }
  }

  void encode(KeyedArchive json) {
    super.encode(json);
    json.encode("description", description);
    if (type == APIType.array) {
      json.encodeObject("items", items);
    }
  }
}
