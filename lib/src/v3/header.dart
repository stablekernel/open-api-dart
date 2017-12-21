import 'package:open_api/src/v3/parameter.dart';

/// [APIHeader] follows the structure of the [APIParameter] with the following changes:
///
/// name MUST NOT be specified, it is given in the corresponding headers map.
/// in MUST NOT be specified, it is implicitly in header.
/// All traits that are affected by the location MUST be applicable to a location of header (for example, style).
class APIHeader extends APIParameter {
  APIHeader() : super();

  final String name = null;
  final APIParameterLocation location = APIParameterLocation.header;
}
