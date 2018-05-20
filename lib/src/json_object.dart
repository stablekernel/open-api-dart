import 'dart:collection';
import 'package:open_api/src/util.dart';
import 'package:cast/cast.dart' as cast;

class _Coder {
  _Coder(this.document);

  final JSONObject document;

  JSONObject resolve(Uri ref) {
    return ref.pathSegments.fold(document, (objectPtr, pathSegment) {
      return objectPtr[pathSegment];
    });
  }
}

class JSONObject extends Object with MapMixin<String, dynamic> {
  JSONObject._empty();

  JSONObject(this._map) {
    _recode();
    _resolve(new _Coder(this));
  }

  JSONObject._(this._map) {
    _recode();
  }

  Map<String, dynamic> _map;
  Uri referenceURI;
  APIObject _inflated;
  JSONObject _objectReference;

  void _recode() {
    const caster = cast.Map(cast.String, cast.any);
    final keys = _map.keys.toList();
    keys.forEach((key) {
      final val = _map[key];
      if (val is Map) {
        _map[key] = new JSONObject._(caster.cast(val));
      } else if (val is List) {
        _map[key] = new _JSONList.fromRaw(val);
      } else if (key == r"$ref") {
        if (val is Map) {
          _objectReference = val;
        } else {
          referenceURI = Uri.parse(Uri.parse(val).fragment);
        }
      }
    });
  }

  void _resolve(_Coder coder) {
    if (referenceURI != null) {
      _objectReference = coder.resolve(referenceURI);
    }

    _map.forEach((key, val) {
      if (val is JSONObject) {
        val._resolve(coder);
      } else if (val is _JSONList) {
        val.resolve(coder);
      }
    });
  }

  void setSchema(Map<String, cast.Cast> schema) {
    if (schema == null) {
      return;
    }

    final caster = new cast.Keyed(schema);
    _map = caster.cast(_map);

    if (_objectReference != null) {
      // todo: can optimize this by only running it once
      _objectReference._map = caster.cast(_objectReference._map);
    }
  }

  operator []=(String key, dynamic value) {
    _map[key] = value;
  }

  dynamic operator [](Object key) => _getValue(key);

  Iterable<String> get keys => _map.keys;

  void clear() => _map.clear();

  dynamic remove(Object key) => _map.remove(key);

  dynamic _getValue(String key) {
    if (_map.containsKey(key)) {
      return _map[key];
    }

    return _objectReference?._getValue(key);
  }

  /* decode */

  T _decodedObject<T extends APIObject>(JSONObject raw, T inflate()) {
    if (raw._inflated == null) {
      raw._inflated = inflate();
      raw._inflated.decode(raw);
    }

    return raw._inflated;
  }

  dynamic decode(String key) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    return v;
  }

  Uri decodeUri(String key) {
    final v = _getValue(key);
    if (v == null) {
      return null;
    }

    return Uri.parse(v);
  }

  T decodeObject<T extends APIObject>(String key, T inflate()) {
    final val = _getValue(key);
    if (val == null) {
      return null;
    }

    if (val is! JSONObject) {
      throw new ArgumentError(
          "Cannot decode key '$key' into 'APIObject', because the value is not a Map. Actual value: '$val'.");
    }

    return _decodedObject(val, inflate);
  }

  List<T> decodeObjects<T extends APIObject>(String key, T inflate()) {
    var val = _getValue(key);
    if (val == null) {
      return null;
    }
    if (val is! List) {
      throw new ArgumentError(
          "Cannot decode key '$key' as 'List<T>', because value is not a List. Actual value: '$val'.");
    }

    return (val as List<dynamic>).map((v) => _decodedObject(v, inflate)).toList().cast<T>();
  }

  Map<String, T> decodeObjectMap<T extends APIObject>(String key, T inflate()) {
    var v = _getValue(key);
    if (v == null) {
      return null;
    }

    if (v is! Map<String, dynamic>) {
      throw new ArgumentError("Cannot decode key '$key' as 'Map<String, T>', because value is not a Map. Actual value: '$v'.");
    }

    return new Map.fromIterable(v.keys, key: (k) => k, value: (k) => _decodedObject(v[k], inflate));
  }

  /* encode */

  Map<String, dynamic> _encodedObject(APIObject object) {
    // todo: The problem is we let encoding occur when there is a reference,
    // and when this happens, everything is re-encoded and cyclic values
    // can be re-traversed. We have to prevent encoding values
    // if there is a ref (but we still have to deal with overridden keys)
    var json = new JSONObject._empty().._map = {}..referenceURI = object.referenceURI;
    if (json.referenceURI != null) {
      json._map[r"$ref"] = "#${json.referenceURI.toString()}";
    } else {
      object.encode(json);
    }
    return json;
  }

  void encode<T>(String key, T value) {
    if (value == null) {
      return;
    }

    _map[key] = value;
  }

  void encodeUri(String key, Uri value) {
    final stringRepresentation = value?.toString();
    if (stringRepresentation == null) {
      return;
    }

    _map[key] = stringRepresentation;
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

    var object = <String, dynamic>{};
    value.forEach((k, v) {
      object[k] = _encodedObject(v);
    });

    _map[key] = object;
  }
}

class _JSONList extends Object with ListMixin<dynamic> {
  final List<dynamic> _inner;

  _JSONList() : _inner = [];

  _JSONList.fromRaw(List<dynamic> raw)
      : _inner = raw.map((e) {
          if (e is Map) {
            return new JSONObject._(e);
          } else if (e is List) {
            return _JSONList.fromRaw(e);
          }
          return e;
        }).toList();

  @override
  operator [](int index) => _inner[index];

  @override
  int get length => _inner.length;

  @override
  set length(int length) {
    _inner.length = length;
  }

  @override
  void operator []=(int index, dynamic val) {
    _inner[index] = val;
  }

  @override
  void add(dynamic element) {
    _inner.add(element);
  }

  @override
  void addAll(Iterable<dynamic> iterable) {
    _inner.addAll(iterable);
  }

  void resolve(_Coder coder) {
    _inner.forEach((i) {
      if (i is JSONObject) {
        i._resolve(coder);
      } else if (i is _JSONList) {
        i.resolve(coder);
      }
    });
  }
}
