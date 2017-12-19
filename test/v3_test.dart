import 'package:open_api/v3.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group("Stripe spec", () {
    APIDocument doc;
    Map<String, dynamic> original;

    setUpAll(() {
      // Spec file is too large for pub, and no other way to remove from pub publish
      // than putting in .gitignore. Therefore, this file must be downloaded locally
      // to this path, from this path: https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json
      var file = new File("test/specs/stripe.json");
      var contents = file.readAsStringSync();
      original = JSON.decode(contents);
      doc = new APIDocument.fromJSON(contents);
    });

    test("Has openapi version", () {
      expect(doc.version, "3.0.0");
    });

    test("Has info", () {
      expect(doc.info.title, "Stripe API");
      expect(doc.info.version, "2017-08-15");
      expect(doc.info.description, "The Stripe REST API. Please see https://stripe.com/docs/api for more details.");
      expect(doc.info.termsOfServiceURL, "https://stripe.com/us/terms/");
      expect(doc.info.contact.email, "dev-platform@stripe.com");
      expect(doc.info.contact.name, "Stripe Dev Platform Team");
      expect(doc.info.contact.url, "https://stripe.com");
      expect(doc.info.license, isNull);
    });

    test("Has servers", () {
      expect(doc.servers.length, 1);
      expect(doc.servers.first.url, "https://api.stripe.com/");
      expect(doc.servers.first.description, isNull);
      expect(doc.servers.first.variables, isNull);
    });

    test("Tags", () {
      expect(doc.tags, isNull);
    });

    group("Paths", () {

    });

    group("Components", () {

    });

    test("Security requirement", () {
      expect(doc.security, isNull);
    });
  });
}
