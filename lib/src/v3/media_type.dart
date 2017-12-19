import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/v3/schema.dart';
import 'package:open_api/src/v3/encoding.dart';
import 'package:open_api/src/util.dart';

class APIMediaType extends APIObject {
  APISchemaObject schema;
  Map<String, APIEncoding> encoding = {};

  void decode(JSONObject json) {
    schema = json.decode("schema", inflate: () => new APISchemaObject());
    encoding = json.decodeObjectMap("encoding", () => new APIEncoding());
  }

  void encode(JSONObject json) {
    json.encodeObject("schema", schema);
    json.encodeObjectMap("encoding", encoding);
  }
}
