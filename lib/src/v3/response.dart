import 'package:open_api_forked/src/object.dart';
import 'package:open_api_forked/src/v3/header.dart';
import 'package:open_api_forked/src/v3/media_type.dart';
import 'package:open_api_forked/src/v3/schema.dart';

/// Describes a single response from an API Operation, including design-time, static links to operations based on the response.
class APIResponse extends APIObject {
  APIResponse.empty();
  APIResponse(this.description, {this.content, this.headers});
  APIResponse.schema(this.description, APISchemaObject schema,
      {Iterable<String> contentTypes: const ["application/json"],
      this.headers}) {
    content = contentTypes.fold<Map<String, APIMediaType?>>({}, (prev, elem) {
      prev[elem] = APIMediaType(schema: schema);
      return prev;
    });
  }

  /// A short description of the response.
  ///
  /// REQUIRED. CommonMark syntax MAY be used for rich text representation.
  String? description;

  /// Maps a header name to its definition.
  ///
  /// RFC7230 states header names are case insensitive. If a response header is defined with the name "Content-Type", it SHALL be ignored.
  Map<String, APIHeader?>? headers;

  /// A map containing descriptions of potential response payloads.
  ///
  /// The key is a media type or media type range and the value describes it. For responses that match multiple keys, only the most specific key is applicable. e.g. text/plain overrides text/*
  Map<String, APIMediaType?>? content;

  // Currently missing:
  // links

  /// Adds a [header] to [headers] for [name].
  ///
  /// If [headers] is null, it is created. If the key does not exist in [headers], [header] is added for the key.
  /// If the key exists, [header] is not added. (To replace a header, access [headers] directly.)
  void addHeader(String name, APIHeader? header) {
    final headers = this.headers ??= {};
    if (!headers.containsKey(name)) {
      headers[name] = header;
    }
  }

  /// Adds a [bodyObject] to [content] for a content-type.
  ///
  /// [contentType] must take the form 'primaryType/subType', e.g. 'application/json'. Do not include charsets.
  ///
  /// If [content] is null, it is created. If [contentType] does not exist in [content], [bodyObject] is added for [contentType].
  /// If [contentType] exists, the [bodyObject] is added the list of possible schemas that were previously added.
  void addContent(String contentType, APISchemaObject? bodyObject) {
    final content = this.content ??= {};

    final key = contentType;
    final existingContent = content[key];
    if (existingContent == null) {
      content[key] = APIMediaType(schema: bodyObject);
      return;
    }

    final schema = existingContent.schema;
    final oneOf = schema?.oneOf;
    if (oneOf != null) {
      oneOf.add(bodyObject);
    } else {
      final container = APISchemaObject()..oneOf = [schema, bodyObject];
      existingContent.schema = container;
    }
  }

  void decode(KeyedArchive object) {
    super.decode(object);

    description = object.decode("description");
    content = object.decodeObjectMap("content", () => APIMediaType());
    headers = object.decodeObjectMap("headers", () => APIHeader());
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    if (description == null) {
      throw ArgumentError(
          "APIResponse must have non-null values for: 'description'.");
    }

    object.encode("description", description);
    object.encodeObjectMap("headers", headers);
    object.encodeObjectMap("content", content);
  }
}
