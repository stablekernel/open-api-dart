import 'dart:convert';

import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/metadata.dart';

import 'package:open_api/src/v3/path.dart';

import 'package:open_api/src/v3/components.dart';
import 'package:open_api/src/v3/server.dart';

/// Represents an OpenAPI 2.0 specification.
class APIDocument extends APIObject with JSONObjectCache {
  /// Creates an empty specification.
  APIDocument();

  /// Creates a specification from JSON.
  APIDocument.fromJSON(String jsonString) {
    _root = JSON.decode(jsonString, reviver: (k, v) {
      if (v is Map) {
        return new JSONObject(v, this);
      }

      return v;
    });

    decode(_root);

    // Can release this once we're done, since it is just a duplicate structure to the one rooted by this instance.
    _root = null;
  }

  String version = "3.0.0";
  APIInfo info = new APIInfo();
  List<APIServerDescription> servers = [];
  Map<String, APIPath> paths = {};
  APIComponents components = new APIComponents();
  List<Map<String, List<String>>> security = [];
  List<APITag> tags = [];

  JSONObject get root => _root;
  JSONObject _root;

  Map<String, dynamic> asMap() {
    _root = new JSONObject({}, this);

    encode(_root);

    var m = _root;
    _root = null;
    return m.asMap();
  }

  void decode(JSONObject object) {
    super.decode(object);

    version = object.decode("openapi");
    info = object.decode("info", inflate: () => new APIInfo());
    servers = object.decodeObjects("servers", () => new APIServerDescription());
    paths = object.decodeObjectMap("paths", () => new APIPath());
    components =
        object.decode("components", inflate: () => new APIComponents());
    security = object.decode("security");
    tags = object.decodeObjects("tags", () => new APITag());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("openapi", version);
    object.encodeObject("info", info);
    object.encodeObjects("servers", servers);
    object.encodeObjectMap("paths", paths);
    object.encodeObject("components", components);
    object.encode("security", security);
    object.encodeObjects("tags", tags);
  }
}
