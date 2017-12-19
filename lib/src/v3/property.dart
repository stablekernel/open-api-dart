import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/types.dart';

enum APISchemaRepresentation {
  primitive, array, object, structure, unknownOrInvalid
}

enum APICollectionFormat {
  csv, ssv, tsv, pipes
}

class APICollectionFormatCodec {
  static APICollectionFormat decode(String location) {
    switch (location) {
      case "csv": return APICollectionFormat.csv;
      case "ssv": return APICollectionFormat.ssv;
      case "tsv": return APICollectionFormat.tsv;
      case "pipes": return APICollectionFormat.pipes;
    }

    return null;
  }

  static String encode(APICollectionFormat location) {
    switch (location) {
      case APICollectionFormat.csv:
        return "csv";
      case APICollectionFormat.ssv:
        return "ssv";
      case APICollectionFormat.tsv:
        return "tsv";
      case APICollectionFormat.pipes:
        return "pipes";
    }
    return null;
  }
}
class APIProperty extends APIObject {
  APIType type;
  String format;


  APICollectionFormat collectionFormat;
  dynamic defaultValue;
  num maximum;
  bool exclusiveMaximum;
  num minimum;
  bool exclusiveMinimum;
  int maxLength;
  int minLength;
  String pattern;
  int maxItems;
  int minItems;
  bool uniqueItems;
  num multipleOf;
  List<dynamic> enumerated;

  APISchemaRepresentation get representation {
    if (type == APIType.array) {
      return APISchemaRepresentation.array;
    } else if (type == APIType.object) {
      return APISchemaRepresentation.object;
    }

    return APISchemaRepresentation.primitive;
  }

  void decode(JSONObject json) {
    type = APITypeCodec.decode(json.decode("type"));
    format = json.decode("format");
    collectionFormat = APICollectionFormatCodec.decode(json.decode("collectionFormat"));
    defaultValue = json.decode("default");
    maximum = json.decode("maximum");
    exclusiveMaximum = json.decode("exclusiveMaximum");
    minimum = json.decode("minimum");
    exclusiveMinimum = json.decode("exclusiveMinimum");
    maxLength = json.decode("maxLength");
    minLength = json.decode("minLength");
    pattern = json.decode("pattern");
    maxItems = json.decode("maxItems");
    minItems = json.decode("minItems");
    uniqueItems = json.decode("uniqueItems");
    multipleOf = json.decode("multipleOf");
    enumerated = json.decode("enum");
  }

  void encode(JSONObject json) {
    json.encode("type", APITypeCodec.encode(type));
    json.encode("format", format);
    json.encode("collectionFormat", APICollectionFormatCodec.encode(collectionFormat));
    json.encode("default", defaultValue);
    json.encode("maximum", maximum );
    json.encode("exclusiveMaximum", exclusiveMaximum);
    json.encode("minimum", minimum);
    json.encode("exclusiveMinimum", exclusiveMinimum);
    json.encode("maxLength", maxLength);
    json.encode("minLength", minLength);
    json.encode("pattern", pattern);
    json.encode("maxItems", maxItems);
    json.encode("minItems", minItems);
    json.encode("uniqueItems", uniqueItems);
    json.encode("multipleOf", multipleOf);
    json.encode("enum", enumerated);
  }
}