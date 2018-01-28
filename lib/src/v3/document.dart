import 'dart:convert';

import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/components.dart';
import 'package:open_api/src/v3/metadata.dart';
import 'package:open_api/src/v3/path.dart';
import 'package:open_api/src/v3/security.dart';
import 'package:open_api/src/v3/server.dart';

/// This is the root document object of the OpenAPI document.
class APIDocument extends APIObject with JSONObjectCache {
  /// Creates an empty specification.
  APIDocument();

  /// Creates a specification from JSON encoded string.
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

  /// This string MUST be the semantic version number of the OpenAPI Specification version that the OpenAPI document uses.
  ///
  /// REQUIRED. The openapi field SHOULD be used by tooling specifications and clients to interpret the OpenAPI document. This is not related to the API info.version string.
  String version = "3.0.0";

  /// Provides metadata about the API.
  ///
  /// REQUIRED. The metadata MAY be used by tooling as required.
  APIInfo info;

  /// An array of [APIServerDescription], which provide connectivity information to a target server.
  ///
  /// If the servers property is not provided, or is an empty array, the default value would be a [APIServerDescription] with a url value of /.
  List<APIServerDescription> servers;

  /// The available paths and operations for the API.
  ///
  /// REQUIRED.
  Map<String, APIPath> paths;

  /// An element to hold various schemas for the specification.
  APIComponents components;

  /// A declaration of which security mechanisms can be used across the API.
  ///
  /// The list of values includes alternative security requirement objects that can be used. Only one of the security requirement objects need to be satisfied to authorize a request. Individual operations can override this definition.
  List<APISecurityRequirement> security;

  /// A list of tags used by the specification with additional metadata.
  ///
  /// The order of the tags can be used to reflect on their order by the parsing tools. Not all tags that are used by the Operation Object must be declared. The tags that are not declared MAY be organized randomly or based on the tools' logic. Each tag name in the list MUST be unique.
  List<APITag> tags;

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
    info = object.decode("info", inflate: () => new APIInfo.empty());
    servers = object.decodeObjects("servers", () => new APIServerDescription.empty());
    paths = object.decodeObjectMap("paths", () => new APIPath());
    components =
        object.decode("components", inflate: () => new APIComponents());
    security = object.decode("security");
    tags = object.decodeObjects("tags", () => new APITag.empty());
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (version == null || info == null || paths == null) {
      throw new APIException("APIDocument must have non-null values for: 'version', 'info', 'paths'.");
    }
    
    object.encode("openapi", version);
    object.encodeObject("info", info);
    object.encodeObjects("servers", servers);
    object.encodeObjectMap("paths", paths);
    object.encodeObject("components", components);
    object.encode("security", security);
    object.encodeObjects("tags", tags);
  }
}
