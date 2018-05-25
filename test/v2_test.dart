// Copyright (c) 2017, joeconway. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:open_api/v2.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group("Kubernetes spec", () {
    APIDocument doc;
    Map<String, dynamic> original;

    setUpAll(() {
      // Spec file is too large for pub, and no other way to remove from pub publish
      // than putting in .gitignore. Therefore, this file must be downloaded locally
      // to this path, from this path: https://github.com/kubernetes/kubernetes/blob/master/api/openapi-spec/swagger.json.
      var file = new File("test/specs/kubernetes.json");
      var contents = file.readAsStringSync();
      original = json.decode(contents);
      doc = new APIDocument.fromMap(original);
    });

    test("Has all metadata", () {
      expect(doc.version, "2.0");
      expect(doc.info.title, "Kubernetes");
      expect(doc.info.version, isNotNull);
      expect(doc.host, isNull);
      expect(doc.basePath, isNull);
      expect(doc.tags, isNull);
      expect(doc.schemes, isNull);
    });

    test("Missing top-level objects", () {
      expect(doc.consumes, isNull);
      expect(original.containsKey("consumes"), false);

      expect(doc.produces, isNull);
      expect(original.containsKey("produces"), false);
    });

    test("Has paths", () {
      expect(doc.paths.length, greaterThan(0));
      expect(doc.paths.length, original["paths"].length);

      Map<String, dynamic> originalPaths = original["paths"];
      doc.paths.forEach((k, v) {
        expect(originalPaths.keys.contains(k), true);
      });
    });

    test("Sample - Namespace", () {
      var namespacePath = doc.paths["/api/v1/namespaces"];

      var getNamespace = namespacePath.operations["get"];
      expect(getNamespace.description, contains("of kind Namespace"));
      expect(getNamespace.consumes, ["*/*"]);
      expect(getNamespace.produces, contains("application/json"));
      expect(getNamespace.produces, contains("application/yaml"));
      expect(getNamespace.parameters.length, 8);
      expect(getNamespace.parameters.firstWhere((p) => p.name == "limit").location, APIParameterLocation.query);
      expect(getNamespace.parameters.firstWhere((p) => p.name == "limit").type, APIType.integer);
      expect(getNamespace.responses.keys, contains("401"));
      expect(getNamespace.responses.keys, contains("200"));

      var postNamespace = namespacePath.operations["post"];
      expect(postNamespace.parameters.length, 1);
      expect(postNamespace.parameters.first.name, "body");
      expect(postNamespace.parameters.first.location, APIParameterLocation.body);
    });

    test("Sample - Reference", () {
      var apiPath = doc.paths["/api/"];
      var apiPathGet = apiPath.operations["get"];
      var response = apiPathGet.responses["200"];
      var schema = response.schema;
      expect(schema.description, contains("APIVersions lists the"));
      expect(schema.required, ["versions", "serverAddressByClientCIDRs"]);
      expect(schema.properties["serverAddressByClientCIDRs"].items.properties["clientCIDR"].description, contains("The CIDR"));
    });

    test("Can encode as JSON", () {
      expect(json.encode(doc.asMap()), new isInstanceOf<String>());
    });
  });
}
