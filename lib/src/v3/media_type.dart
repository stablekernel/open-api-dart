import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/encoding.dart';
import 'package:open_api/src/util.dart';

class APIMediaType extends APIObject {
  APISchemaObject schema;
  Map<String, APIEncoding> encoding = {};

  void decode(JSONObject object) {
    super.decode(object);

    schema = object.decode("schema", inflate: () => new APISchemaObject());
    encoding = object.decodeObjectMap("encoding", () => new APIEncoding());
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encodeObject("schema", schema);
    object.encodeObjectMap("encoding", encoding);
  }
}
