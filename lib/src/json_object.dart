import 'dart:collection';
import 'util.dart';

class JSONObject {
  JSONObject(this._map, {this.parent}) {
    if (_map.containsKey(r"$ref")) {
      _referenceURI = _map[r"$ref"];
      _referencedMap = parent.resolve(_referenceURI);
      _map.remove(r"$ref");
    }
  }

  Iterable<String> get keys => [_map.keys, _referencedMap?.keys ?? []].expand((a) => a);

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};
    m.addAll(_map);
    if (_referenceURI != null) {
      m[r"$ref"] = _referenceURI;
    }
    return m;
  }

  Map<String, dynamic> _map;
  Map<String, dynamic> _referencedMap;
  String _referenceURI;

  JSONObject parent;

  dynamic resolve(String ref) {
    return _resolve(Uri.parse(Uri.parse(ref).fragment));
  }

  Map<String, dynamic> _resolve(Uri ref) {
    var p = this;
    while (p.parent != null) {
      p = p.parent;
    }

    return ref.pathSegments.fold(p._map, (objectPtr, pathSegment) {
      return objectPtr[pathSegment];
    });
  }

  dynamic _getValue(String key) {
    if (_map.containsKey(key)) {
      return _map[key];
    }

    if (_referencedMap?.containsKey(key) ?? false) {
      return _referencedMap[key];
    }

    return null;
  }

  T decode<T extends APIObject>(String key, {T objectDecoder(dynamic v)}) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    if (objectDecoder != null) {
      var j = new JSONObject(v, parent: this);
      return objectDecoder(j)
        ..referenceURL = j._referenceURI;
    }

    return v;
  }

  Map<String, T> decodeObjectMap<T extends APIObject>(String key, T inflate(dynamic value)) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    return new Map.fromIterable(v.keys,
        key: (k) => k, value: (k) => inflate(new JSONObject(v[k], parent: this)));
  }

  List<T> decodeObjects<T extends APIObject>(String key, T inflate(dynamic value)) {
    var contents = _getValue(key);
    if (contents == null) {
      return null;
    }

    return contents.map((v) => inflate(new JSONObject(v, parent: this))).toList();
  }

  void encodeObjectMap<T extends APIObject>(String key, Map<String, T> value) {
    if (value == null) {
      return;
    }

    var object = new JSONObject({});
    value.forEach((k, v) {
      object.encodeObject(k, v);
    });

    _map[key] = object.asMap();
  }

  void encode<T>(String key, T value) {
    if (value == null) {
      return;
    }

    _map[key] = value;
  }

  void encodeObject(String key, APIObject value) {
    if (value == null) {
      return;
    }

    _map[key] = _encodedObject(value);
  }

  Map<String, dynamic> _encodedObject(APIObject object) {
    var json = new JSONObject({}, parent: this);
    if (object.referenceURL != null) {
      json._referenceURI = object.referenceURL;
    } else {
      object.encodeInto(json);
    }
    return json.asMap();
  }

  void encodeObjects(String key, List<APIObject> value) {
    if (value == null) {
      return;
    }

    _map[key] = value.map((v) => _encodedObject(v)).toList();
  }
}
