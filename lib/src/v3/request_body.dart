import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/media_type.dart';

/// Describes a single request body.
class APIRequestBody extends APIObject {
  APIRequestBody.empty();

  APIRequestBody(this.content, {this.description, bool required}) {
    this.isRequired = required;
  }

  /// A brief description of the request body.
  ///
  /// This could contain examples of use. CommonMark syntax MAY be used for rich text representation.
  String description;

  /// The content of the request body.
  ///
  /// REQUIRED. The key is a media type or media type range and the value describes it. For requests that match multiple keys, only the most specific key is applicable. e.g. text/plain overrides text/*
  Map<String, APIMediaType> content;

  /// Determines if the request body is required in the request.
  ///
  /// Defaults to false.
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

    if (content == null) {
      throw new APIException("APIRequestBody must have non-null values for: 'content'.");
    }

    object.encode("description", description);
    object.encode("required", _required);
    object.encodeObjectMap("content", content);
  }
}
