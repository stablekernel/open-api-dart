import 'package:open_api/v3.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group("Components and resolution", () {
    test("Can resolve object against registry", () {
      final components = new APIComponents();
      components.schemas["foo"] = new APISchemaObject.string();

      final ref = new APISchemaObject()..referenceURI = Uri.parse("/components/schemas/foo");
      final orig = components.resolve(ref);
      expect(orig.type, APIType.string);
      expect(ref.type, isNull);

      final APISchemaObject constructed = components.resolveUri(Uri(path: "/components/schemas/foo"));
      expect(constructed.type, APIType.string);
    });

    test("Invalid ref uri format throws error", () {
      final components = new APIComponents();
      try {
        components.resolve(new APISchemaObject()..referenceURI = Uri.parse("#/components/schemas/foo"));
        expect(true, false);
      } on ArgumentError catch (e) {
        expect(e.message, contains("Invalid reference URI"));
      }

      try {
        components.resolve(new APISchemaObject()..referenceURI = Uri.parse("#/components/schemas"));
        expect(true, false);
      } on ArgumentError catch (e) {
        expect(e.message, contains("Invalid reference URI"));
      }

      try {
        components.resolve(new APISchemaObject()..referenceURI = Uri.parse("/components/foobar/foo"));
        expect(true, false);
      } on ArgumentError catch (e) {
        expect(e.message, contains("Invalid reference URI"));
      }
    });

    test("Nonexisting component returns null", () {
      final components = new APIComponents();
      expect(components.resolve(new APISchemaObject()..referenceURI = Uri.parse("/components/schemas/foo")), isNull);
    });

    test("URIs are paths internally, but fragments when serialized", () {
      final doc = new APIDocument.fromMap({
        "openapi": "3.0.0",
        "info": {"title":"x", "version":"1"},
        "paths": <String, dynamic>{},
        "components": {
          "schemas": {
            "string": {
              "type": "string",
            },
            "container": {
              "\$ref": "#/components/schemas/string"
            }
          }
        }
      });

      expect(doc.components.schemas["container"].referenceURI.path, "/components/schemas/string");

      doc.components.schemas["other"] = new APISchemaObject()..referenceURI = Uri(path: "/components/schemas/container");

      final out = doc.asMap();
      expect(out["components"]["schemas"]["container"][r"$ref"], "#/components/schemas/string");
      expect(out["components"]["schemas"]["other"][r"$ref"], "#/components/schemas/container");
    });
  });

  group("Stripe spec", () {
    APIDocument doc;
    Map<String, dynamic> original;

    setUpAll(() {
      // Spec file is too large for pub, and no other way to remove from pub publish
      // than putting in .gitignore. Therefore, this file must be downloaded locally
      // to this path, from this path: https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json
      var file = new File("test/specs/stripe.json");
      var contents = file.readAsStringSync();
      original = json.decode(contents);
      doc = new APIDocument.fromMap(original);
    });

    test("Emits same document in asMap()", () {
      expect(doc.asMap(), original);
    });

    test("Has openapi version", () {
      expect(doc.version, "3.0.0");
    });

    test("Has info", () {
      expect(doc.info.title, "Stripe API");
      expect(doc.info.version, isNotNull);
      expect(doc.info.description, "The Stripe REST API. Please see https://stripe.com/docs/api for more details.");
      expect(doc.info.termsOfServiceURL.toString(), "https://stripe.com/us/terms/");
      expect(doc.info.contact.email, "dev-platform@stripe.com");
      expect(doc.info.contact.name, "Stripe Dev Platform Team");
      expect(doc.info.contact.url.toString(), "https://stripe.com");
      expect(doc.info.license, isNull);
    });

    test("Has servers", () {
      expect(doc.servers.length, 1);
      expect(doc.servers.first.url.toString(), "https://api.stripe.com/");
      expect(doc.servers.first.description, isNull);
      expect(doc.servers.first.variables, isNull);
    });

    test("Tags", () {
      expect(doc.tags, isNull);
    });

    group("Paths", () {
      test("Sample path 1", () {
        final p = doc.paths["/v1/transfers/{transfer}/reversals/{id}"];
        expect(p, isNotNull);
        expect(p.description, isNull);

        expect(p.operations.length, 2);

        final getOp = p.operations["get"];
        final getParams = getOp.parameters;
        final getResponses = getOp.responses;
        expect(getOp.description, contains("10 most recent reversals"));
        expect(getOp.id, "TransferReversalRetrieve");
        expect(getParams.length, 3);
        expect(getParams[0].location, APIParameterLocation.query);
        expect(getParams[0].description, "Specifies which fields in the response should be expanded.");
        expect(getParams[0].name, "expand");
        expect(getParams[0].isRequired, false);
        expect(getParams[0].schema.type, APIType.array);
        expect(getParams[0].schema.items.type, APIType.string);

        expect(getParams[1].location, APIParameterLocation.path);
        expect(getParams[1].name, "id");
        expect(getParams[1].isRequired, true);
        expect(getParams[1].schema.type, APIType.string);

        expect(getParams[2].location, APIParameterLocation.path);
        expect(getParams[2].name, "transfer");
        expect(getParams[2].isRequired, true);
        expect(getParams[2].schema.type, APIType.string);

        expect(getResponses.length, 2);
        expect(getResponses["200"].content.length, 1);
        expect(getResponses["200"].content["application/json"].schema.referenceURI, Uri.parse(Uri.parse("#/components/schemas/transfer_reversal").fragment));

        final resolvedElement = getResponses["200"].content["application/json"].schema.properties["balance_transaction"].anyOf;
        expect(resolvedElement.last.properties["amount"].type, APIType.integer);
      });
    });

    group("Components", () {

    });

    test("Security requirement", () {
      expect(doc.security, isNull);
    });
  });

  group("Schema", () {
    test("Can read/emit schema object with additionalProperties=true", () {
      final doc = new APIDocument.fromMap({
        "openapi": "3.0.0",
        "info": {"title":"x", "version":"1"},
        "paths": <String, dynamic>{},
        "components": {
          "schemas": {
            "freeform": {
              "type": "object",
              "additionalProperties": true
            }
          }
        }
      });

      expect(doc.components.schemas["freeform"].additionalPropertyPolicy, APISchemaAdditionalPropertyPolicy.freeForm);

      expect(doc.asMap()["components"]["schemas"]["freeform"]["type"], "object");
      expect(doc.asMap()["components"]["schemas"]["freeform"]["additionalProperties"], true);
    });

    test("Can read/emit schema object with additionalProperties={}", () {
      final doc = new APIDocument.fromMap({
        "openapi": "3.0.0",
        "info": {"title":"x", "version":"1"},
        "paths": <String, dynamic>{},
        "components": {
          "schemas": {
            "freeform": {
              "type": "object",
              "additionalProperties": <String, dynamic>{}
            }
          }
        }
      });
      expect(doc.components.schemas["freeform"].additionalPropertyPolicy, APISchemaAdditionalPropertyPolicy.freeForm);
      expect(doc.asMap()["components"]["schemas"]["freeform"]["type"], "object");
      expect(doc.asMap()["components"]["schemas"]["freeform"]["additionalProperties"], true);
    });

  });

  group("Callbacks", () {
  });

  group("'add' methods", () {
    test("'addHeader'", () {
      var resp = new APIResponse("Response");

      // when null
      resp.addHeader("x", new APIHeader(schema: new APISchemaObject.string(format: "initial")));
      expect(resp.headers["x"].schema.format, "initial");

      // add more than one
      resp.addHeader("y", new APIHeader(schema: new APISchemaObject.string(format: "second")));
      expect(resp.headers["x"].schema.format, "initial");
      expect(resp.headers["y"].schema.format, "second");

      // cannot replace
      resp.addHeader("y", new APIHeader(schema: new APISchemaObject.string(format: "third")));
      expect(resp.headers["x"].schema.format, "initial");
      expect(resp.headers["y"].schema.format, "second");
    });

    test("'addContent'", () {
      var resp = new APIResponse("Response");

      // when null
      resp.addContent("x/a", new APISchemaObject.string(format: "initial"));
      expect(resp.content["x/a"].schema.format, "initial");

      // add more than one
      resp.addContent("y/a", new APISchemaObject.string(format: "second"));
      expect(resp.content["x/a"].schema.format, "initial");
      expect(resp.content["y/a"].schema.format, "second");

      // joins schema in oneOf if key exists
      resp.addContent("y/a", new APISchemaObject.string(format: "third"));
      expect(resp.content["x/a"].schema.format, "initial");

      expect(resp.content["y/a"].schema.oneOf.first.format, "second");
      expect(resp.content["y/a"].schema.oneOf.last.format, "third");
    });

    test("'addResponse'", () {
      var op = new APIOperation("op", null);

      // when null
      op.addResponse(200, new APIResponse.schema("OK", new APISchemaObject.string(format: "initial")));
      expect(op.responses["200"].content["application/json"].schema.format, "initial");

      // add more than one
      op.addResponse(400, new APIResponse.schema("KINDABAD", new APISchemaObject.string(format: "second"), headers: {
        "initial": new APIHeader(schema: new APISchemaObject.string(format: "initial"))
      }));
      expect(op.responses["200"].content["application/json"].schema.format, "initial");
      expect(op.responses["400"].content["application/json"].schema.format, "second");

      // join responses when key exists
      op.addResponse(400, new APIResponse.schema("REALBAD", new APISchemaObject.string(format: "third"), headers: {
        "second": new APIHeader(schema: new APISchemaObject.string(format: "initial"))
      }));
      expect(op.responses["200"].content["application/json"].schema.format, "initial");

      final r400 = op.responses["400"];
      expect(r400.description, contains("KINDABAD"));
      expect(r400.description, contains("REALBAD"));
      expect(r400.content["application/json"].schema.oneOf, isNotNull);
      expect(r400.headers["initial"], isNotNull);
      expect(r400.headers["second"], isNotNull);
    });

    test("'addResponse' guards against null value", () {
      var op = new APIOperation("op", null);

      op.addResponse(400, new APIResponse.schema("KINDABAD", APISchemaObject.string(format: "second")));
      expect(op.responses["400"].content["application/json"].schema.format, "second");

      op.addResponse(400, new APIResponse.schema("REALBAD", new APISchemaObject.string(format: "third")));
      expect(op.responses["400"].content["application/json"].schema.oneOf.length, 2);
    });
  });;
}
