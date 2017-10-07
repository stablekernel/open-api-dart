import '../generator.dart';
import '../document.dart';
import '../json_object.dart';
import '../schema.dart';
import '../types.dart';

typedef String _DefinitionNamer(String longName);

class DartGenerator implements Generator {
  DartGenerator(this.document, this.namer);

  APIDocument document;
  _DefinitionNamer namer;


  Map<String, String> get fileSources {
    var definitions = document.definitions.keys.map((name) {
      return generateDefinition(name, document.definitions[name]);
    }).where((def) => def != null).toList();

    print("${definitions}");
    // generate all base models

    return {};
  }

  String generateDefinition(String name, APISchemaObject object) {
    if(object.properties != null) {
      StringBuffer buf = new StringBuffer();

      buf.writeln("class ${namer(name)} {");

      // If items is a ref, then it has a name. if it is an array, then nest one deeper.
      // if it has props/addlProps, then it is a map. otheriwse, it is its type

      object.properties.forEach((propName, nextObject) {
        buf.writeln("  ${typeName(nextObject)} $propName;");
      });

      buf.writeln("}");

      return buf.toString();
    }

    return null;
  }

  String camelCase(String text) {
    var firstChar = text[0];
    return text.replaceRange(0, 1, firstChar.toLowerCase());
  }

  String typeName(APISchemaObject object) {
    switch (object.type) {
      case APIType.string: return "String";
      case APIType.integer: return "int";
      case APIType.number: return "num";
      case APIType.boolean: return "bool";
      case APIType.array: return "List<${typeName(object.items)}>";
      case APIType.file: return "dynamic";
    }

    if (object.referenceURI != null) {
      return namer(object.referenceURI);
    }

    return "dynamic";
  }


}