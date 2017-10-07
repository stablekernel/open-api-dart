import 'document.dart';
import 'generators/dart.dart';

abstract class Generator {
  factory Generator(String language, APIDocument document, {String definitionNamer(String longName)}) {
    if (language == "dart") {
      return new DartGenerator(document, definitionNamer);
    }

    throw new Exception("Unsupported language '$language'");
  }

  APIDocument document;

  Map<String, String> get fileSources;
}