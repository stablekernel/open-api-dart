import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/path.dart';
import 'package:open_api/src/util.dart';

/// A map of possible out-of band callbacks related to the parent operation.
///
/// Each value in the map is a [APIPath] that describes a set of requests that may be initiated by the API provider and the expected responses. The key value used to identify the callback object is an expression, evaluated at runtime, that identifies a URL to use for the callback operation.
class APICallback extends APIObject {
  APICallback({this.paths});

  /// Callback paths.
  ///
  /// The key that identifies the [APIPath] is a runtime expression that can be evaluated in the context of a runtime HTTP request/response to identify the URL to be used for the callback request. A simple example might be $request.body#/url.
  Map<String, APIPath> paths = {};

  void decode(JSONObject object) {
    super.decode(object);

    paths = {};
    object.forEach((key, JSONObject value) {
      paths[key] = value.decode(key, inflate: () => new APIPath());
    });
  }

  void encode(JSONObject object) {
    super.encode(object);
    throw new Exception("not yet impemented");
  }
}
