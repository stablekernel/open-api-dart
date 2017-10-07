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
  static RegExp _listTypeParser = new RegExp(r"List\<([A-Za-z0-9_]*)\>");

  String generateDefinition(String name, APISchemaObject object) {
    if(object.properties != null) {
      StringBuffer buf = new StringBuffer();

      var className = namer(name);

      buf.writeln("class $className {");

      // If items is a ref, then it has a name. if it is an array, then nest one deeper.
      // if it has props/addlProps, then it is a map. Otherwise, it is its type

      // todo: make all required params final, require them as args to this constructor
      // Type()
      buf.writeln("  $className();");
      buf.writeln("");

      // Type.fromMap(Map values)
      buf.writeln("  $className.fromMap(Map<String, dynamic> values) {");
      object.properties.forEach((propName, nextObject) {
        if (nextObject.referenceURI != null) {
          var type = typeName(nextObject);
          buf.writeln("    $propName = new $type.fromMap(values['$propName']);");
        } else if (nextObject.type == APIType.array) {
          var innerType = typeName(nextObject.items);

          if (nextObject.items.type == null) {
            // Then it is a reference to some other type.
            var listFromMap = "(values['$propName'] as List<Map<String, dynamic>>)";
            var constructor = "new $innerType.fromMap(m)";
            buf.writeln("    $propName = $listFromMap.map((m) => $constructor).toList();");
          } else {
            // Otherwise, it is a list of primitives.
            buf.writeln("    $propName = values['$propName'];");
          }
        } else {
          buf.writeln("    $propName = values['$propName'];");
        }
      });
      buf.writeln("  }");
      buf.writeln("");

      // Property definitions;
      object.properties.forEach((propName, nextObject) {
        buf.writeln("  ${typeName(nextObject)} $propName;");
      });
      buf.writeln("");

      // Map<String, dynamic> asMap()
      buf.writeln("  Map<String, dynamic> asMap() {");
      buf.writeln("    var output = <String, dynamic>{};");
      object.properties.forEach((propName, nextObject) {
        if (nextObject.referenceURI != null) {
          buf.writeln("    output['$propName'] = $propName.asMap();");
        } else if (nextObject.type == APIType.array) {
          if (nextObject.items.type == null) {
            // Then it is a reference to some other type.
            var listFromMap = "$propName";
            var constructor = "m.asMap()";
            buf.writeln("    output['$propName'] = $listFromMap.map((m) => $constructor).toList();");
          } else {
            // Otherwise, it is a list of primitives.
            buf.writeln("    values['$propName'] = $propName;");
          }
        } else {
          buf.writeln("    values['$propName'] = $propName;");
        }
      });
      buf.writeln("    return output;");
      buf.writeln("  }");


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
      case APIType.object: return "Map<String, ${typeName(object.additionalProperties)}>";
    }

    if (object.referenceURI != null) {
      return namer(object.referenceURI);
    }

    return "dynamic";
  }


}