import 'package:open_api_forked/src/object.dart';

/// An object representing a Server.
class APIServerDescription extends APIObject {
  APIServerDescription.empty();
  APIServerDescription(this.url, {this.description, this.variables});

  /// A URL to the target host.
  ///
  /// REQUIRED. This URL supports Server Variables and MAY be relative, to indicate that the host location is relative to the location where the OpenAPI document is being served. Variable substitutions will be made when a variable is named in {brackets}.
  Uri? url;

  /// An optional string describing the host designated by the URL.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String? description;

  /// A map between a variable name and its value.
  ///
  /// The value is used for substitution in the server's URL template.
  Map<String, APIServerVariable?>? variables;

  void decode(KeyedArchive object) {
    super.decode(object);

    url = object.decode("url") != null
        ? Uri.tryParse(object.decode("url"))
        : null;
    description = object.decode("description");
    variables =
        object.decodeObjectMap("variables", () => APIServerVariable.empty());
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    if (url == null) {
      throw ArgumentError(
          "APIServerDescription must have non-null values for: 'url'.");
    }

    object.encode("url", url);
    object.encode("description", description);
    object.encodeObjectMap("variables", variables);
  }
}

/// An object representing a Server Variable for server URL template substitution.
class APIServerVariable extends APIObject {
  APIServerVariable.empty();
  APIServerVariable(this.defaultValue,
      {this.availableValues, this.description});

  /// An enumeration of string values to be used if the substitution options are from a limited set.
  List<String>? availableValues;

  /// The default value to use for substitution, and to send, if an alternate value is not supplied.
  ///
  /// REQUIRED. Unlike the Schema Object's default, this value MUST be provided by the consumer.
  String? defaultValue;

  /// An optional description for the server variable.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String? description;

  void decode(KeyedArchive object) {
    super.decode(object);

    availableValues = List<String>.from(object.decode("enum"));
    defaultValue = object.decode("default");
    description = object.decode("description");
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    if (defaultValue == null) {
      throw ArgumentError(
          "APIServerVariable must have non-null values for: 'defaultValue'.");
    }

    object.encode("enum", availableValues);
    object.encode("default", defaultValue);
    object.encode("description", description);
  }
}
