import 'package:open_api/src/v3/parameter.dart';

/// Represents a header in the OpenAPI specification.
class APIHeader extends APIParameter {
  APIHeader() : super();

  final String name = null;
  final APIParameterLocation location = APIParameterLocation.header;
}
