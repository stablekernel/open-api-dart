import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/media_type.dart';

/// Describes a single response from an API Operation, including design-time, static links to operations based on the response.
class APIResponse extends APIObject {
  APIResponse();

  /// A short description of the response.
  ///
  /// REQUIRED. CommonMark syntax MAY be used for rich text representation.
  String description;

  /// Maps a header name to its definition.
  ///
  /// RFC7230 states header names are case insensitive. If a response header is defined with the name "Content-Type", it SHALL be ignored.
  Map<String, APIHeader> headers;

  /// A map containing descriptions of potential response payloads.
  ///
  /// The key is a media type or media type range and the value describes it. For responses that match multiple keys, only the most specific key is applicable. e.g. text/plain overrides text/*
  Map<String, APIMediaType> content;

  // Currently missing:
  // links

  void decode(JSONObject object) {
    super.decode(object);

    description = object.decode("description");
    content = object.decodeObjectMap("content", () => new APIMediaType());
    headers = object.decodeObjectMap("headers", () => new APIHeader());
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (description == null) {
      throw new APIException("APIResponse must have non-null values for: 'description'.");
    }


    object.encode("description", description);
    object.encodeObjectMap("headers", headers);
    object.encodeObjectMap("content", content);
  }
}
