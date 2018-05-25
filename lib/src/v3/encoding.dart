import 'package:open_api/src/object.dart';
import 'package:open_api/src/v3/header.dart';
import 'package:open_api/src/v3/parameter.dart';

/// A single encoding definition applied to a single schema property.
class APIEncoding extends APIObject {
  APIEncoding({this.contentType, this.headers, this.style, bool allowReserved, bool explode}) {
    this.allowReserved = allowReserved;
    this.explode = explode;
  }

  APIEncoding.empty();

  /// The Content-Type for encoding a specific property.
  ///
  /// Default value depends on the property type: for string with format being binary – application/octet-stream; for other primitive types – text/plain; for object - application/json; for array – the default is defined based on the inner type. The value can be a specific media type (e.g. application/json), a wildcard media type (e.g. image/*), or a comma-separated list of the two types.
  String contentType;

  /// A map allowing additional information to be provided as headers, for example Content-Disposition.
  ///
  /// Content-Type is described separately and SHALL be ignored in this section. This property SHALL be ignored if the request body media type is not a multipart.
  Map<String, APIHeader> headers;

  /// Determines whether the parameter value SHOULD allow reserved characters, as defined by RFC3986 :/?#[]@!$&'()*+,;= to be included without percent-encoding.
  ///
  /// The default value is false. This property SHALL be ignored if the request body media type is not application/x-www-form-urlencoded.
  bool get allowReserved => _allowReserved ?? false;
  set allowReserved(bool f) { _allowReserved = f; }
  bool _allowReserved;

  /// When this is true, property values of type array or object generate separate parameters for each value of the array, or key-value-pair of the map.
  ///
  /// For other types of properties this property has no effect. When style is form, the default value is true. For all other styles, the default value is false. This property SHALL be ignored if the request body media type is not application/x-www-form-urlencoded.
  bool get explode => _explode ?? false;
  set explode(bool f) { _explode = f; }
  bool _explode;

  /// Describes how a specific property value will be serialized depending on its type.
  ///
  /// See [APIParameter] for details on the style property. The behavior follows the same values as query parameters, including default values. This property SHALL be ignored if the request body media type is not application/x-www-form-urlencoded.
  String style;

  void decode(KeyedArchive object) {
    super.decode(object);

    contentType = object.decode("contentType");
    headers = object.decodeObjectMap("headers", () => new APIHeader());
    _allowReserved = object.decode("allowReserved");
    _explode = object.decode("explode");
    style = object.decode("style");
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("contentType", contentType);
    object.encodeObjectMap("headers", headers);
    object.encode("allowReserved", _allowReserved);
    object.encode("explode", _explode);
    object.encode("style", style);
  }
}
