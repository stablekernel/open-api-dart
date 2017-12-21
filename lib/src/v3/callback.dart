import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/path.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/media_type.dart';

/// A map of possible out-of band callbacks related to the parent operation.
///
/// Each value in the map is a Path Item Object that describes a set of requests that may be initiated by the API provider and the expected responses. The key value used to identify the callback object is an expression, evaluated at runtime, that identifies a URL to use for the callback operation.
class APICallback extends APIObject {
  Map<String, APIPath> paths = {};

  void decode(JSONObject object) {
    super.decode(object);

    paths = {};
    object.keys.forEach((key) {
      paths[key] = object.decode(key, inflate: () => new APIPath());
    });
  }

  void encode(JSONObject object) {
    super.encode(object);
    throw new Exception("NYI");
  }
}
