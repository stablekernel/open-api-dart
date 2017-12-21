import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';

/// An object representing a Server.
class APIServerDescription extends APIObject {
  /// A URL to the target host.
  ///
  /// REQUIRED. This URL supports Server Variables and MAY be relative, to indicate that the host location is relative to the location where the OpenAPI document is being served. Variable substitutions will be made when a variable is named in {brackets}.
  Uri url;

  /// An optional string describing the host designated by the URL.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  /// A map between a variable name and its value.
  ///
  /// The value is used for substitution in the server's URL template.
  Map<String, APIServerVariable> variables = {};

  void decode(JSONObject object) {
    super.decode(object);

    url = object.decodeUri("url");
    description = object.decode("description");
    variables =
        object.decodeObjectMap("variables", () => new APIServerVariable());
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (url == null) {
      throw new APIException("APIServerDescription must have non-null values for: 'url'.");
    }

    object.encodeUri("url", url);
    object.encode("description", description);
    object.encodeObjectMap("variables", variables);
  }
}

/// An object representing a Server Variable for server URL template substitution.
class APIServerVariable extends APIObject {
  /// An enumeration of string values to be used if the substitution options are from a limited set.
  List<String> availableValues;

  /// The default value to use for substitution, and to send, if an alternate value is not supplied.
  ///
  /// REQUIRED. Unlike the Schema Object's default, this value MUST be provided by the consumer.
  String defaultValue;

  /// An optional description for the server variable.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  void decode(JSONObject object) {
    super.decode(object);

    availableValues = object.decode("enum");
    defaultValue = object.decode("default");
    description = object.decode("description");
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (defaultValue == null) {
      throw new APIException("APIServerVariable must have non-null values for: 'defaultValue'.");
    }

    object.encode("enum", availableValues);
    object.encode("default", defaultValue);
    object.encode("description", description);
  }
}
