import 'package:codable/codable.dart';
import 'package:open_api/src/v3/parameter.dart';
import 'package:open_api/src/v3/schema.dart';

/// [APIHeader] follows the structure of the [APIParameter] with the following changes:
///
/// name MUST NOT be specified, it is given in the corresponding headers map.
/// in MUST NOT be specified, it is implicitly in header.
/// All traits that are affected by the location MUST be applicable to a location of header (for example, style).
class APIHeader extends APIParameter {
  APIHeader({APISchemaObject schema}) : super.header(null, schema: schema);
  APIHeader.empty() : super.header(null);

  @override
  void encode(KeyedArchive object) {
    name = "temporary";
    super.encode(object);
    object.remove("name");
    object.remove("in");
    name = null;
  }
}
