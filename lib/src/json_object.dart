import 'dart:collection';
import 'util.dart';

abstract class JSONObjectCache {
  JSONObject get root;

  JSONObject resolve(Uri ref) {
    return ref.pathSegments.fold(root._map, (objectPtr, pathSegment) {
      return objectPtr[pathSegment];
    });
  }
}

class JSONObject extends Object with MapMixin<String, dynamic> {
  JSONObject(Map<String, dynamic> map, this.cache) {
    _map = map;

    if (map.containsKey(r"$ref")) {
      try {
        var uri = Uri.parse(map[r"$ref"]);
        _referenceURI = Uri.parse(uri.fragment);
      } catch (_) {}
    }
  }

  Map<String, dynamic> _map;
  Uri _referenceURI;

  APIObject _representation;
  JSONObjectCache cache;

  operator []= (String key, dynamic value) {
    _map[key] = value;
  }
  dynamic operator [] (Object key) {
    return _getValue(key);
  }
  Iterable<String> get keys {
    if (_referenceURI != null) {
      var ref = cache.resolve(_referenceURI);
      return [ref.keys, _map.keys].expand((k) => k);
    }

    return _map.keys;
  }
  void clear() => _map.clear();
  dynamic remove(Object key) => _map.remove(key);

  dynamic _getValue(String key) {
    if (_map.containsKey(key)) {
      return _map[key];
    }

    if (_referenceURI != null) {
      var m = cache.resolve(_referenceURI);
      var v = m._getValue(key);
      if (v != null) {
        return v;
      }
    }

    return null;
  }

  /* decode */

  T _decodedObject<T extends APIObject>(JSONObject values, T inflate()) {
    if (values._representation == null) {
      var representedObject = inflate();
      values._representation = representedObject;
      if (values.containsKey(r"$ref")) {
        values._representation.referenceURI = values._map[r"$ref"];
      }
      representedObject.decode(values);
    }

    return values._representation;
  }

  T decode<T extends APIObject>(String key, {T inflate()}) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    if (inflate != null && v is JSONObject) {
      return _decodedObject(v, inflate);
    }

    return v;
  }

  List<T> decodeObjects<T extends APIObject>(String key, T inflate()) {
    var contents = _getValue(key);
    if (contents == null) {
      return null;
    }

    return contents.map((v) => _decodedObject(v, inflate)).toList();
  }

  Map<String, T> decodeObjectMap<T extends APIObject>(String key, T inflate()) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    return new Map.fromIterable(v.keys,
        key: (k) => k, value: (k) => _decodedObject(v[k], inflate));
  }

  /* encode */

  Map<String, dynamic> _encodedObject(APIObject object) {
    if (object.referenceURI != null) {
      // Note: this means that the encoding of a previously decoded spec is not equal.
      // The decoded spec may have overriding keys that are sibling to a $ref key.
      // References to these keys are not kept by the associated APIObject, and therefore
      // aren't emitted here.
      return {
        r"$ref": object.referenceURI
      };
    }

    var json = new JSONObject({}, cache);
    object.encode(json);
    return json.asMap();
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

  void encodeObjects(String key, List<APIObject> value) {
    if (value == null) {
      return;
    }

    _map[key] = value.map((v) => _encodedObject(v)).toList();
  }

  void encodeObjectMap<T extends APIObject>(String key, Map<String, T> value) {
    if (value == null) {
      return;
    }

    var object = new JSONObject({}, cache);
    value.forEach((k, v) {
      object.encodeObject(k, v);
    });

    _map[key] = object.asMap();
  }

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};
    m.addAll(_map);
    if (_referenceURI != null) {
      m[r"$ref"] = _referenceURI;
    }
    return m;
  }

}
