// Copyright (c) 2017, joeconway. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:conduit_open_api/v2.dart';
import 'package:dcli/dcli.dart';
import 'package:test/test.dart';

void main() {
  group("kubenrnetes spec", () {
    APIDocument? doc;
    Map<String, dynamic>? original;

    setUpAll(() {
      /// download sample api document if we don't already have it.
      final String config = fetchKubernetesExample();
      final file = File(config);
      final contents = file.readAsStringSync();
      original = json.decode(contents) as Map<String, dynamic>;
      doc = APIDocument.fromMap(original!);
    });

    test("Has all metadata", () {
      expect(doc!.version, "2.0");
      expect(doc!.info!.title, "Kubernetes");
      expect(doc!.info!.version, 'v1.12.0');
      expect(doc!.host, isNull);
      expect(doc!.basePath, isNull);
      expect(doc!.tags, isNull);
      expect(doc!.schemes, isNull);
    });

    test("Confirm top-level objects", () {
      expect(original!.containsKey("consumes"), false);

      expect(original!.containsKey("produces"), false);
    });

    test("Has paths", () {
      expect(doc!.paths!.length, greaterThan(0));
      expect(doc!.paths!.length, original!["paths"].length);

      final Map<String, dynamic> originalPaths =
          original!["paths"] as Map<String, dynamic>;
      doc!.paths!.forEach((k, v) {
        expect(originalPaths.keys.contains(k), true);
      });
    });

    test("Sample - Namespace", () {
      final namespacePath = doc!.paths!["/api/v1/namespaces"];

      final getNamespace = namespacePath!.operations["get"];
      expect(getNamespace!.description, contains("of kind Namespace"));
      expect(getNamespace.consumes, ["*/*"]);
      expect(getNamespace.produces, contains("application/json"));
      expect(getNamespace.produces, contains("application/yaml"));
      expect(getNamespace.parameters!.length, 8);
      expect(
          getNamespace.parameters!
              .firstWhere((p) => p!.name == "limit")!
              .location,
          APIParameterLocation.query);
      expect(
          getNamespace.parameters!.firstWhere((p) => p!.name == "limit")!.type,
          APIType.integer);
      expect(getNamespace.responses!.keys, contains("401"));
      expect(getNamespace.responses!.keys, contains("200"));

      final postNamespace = namespacePath.operations["post"];
      expect(postNamespace!.parameters!.length, 1);
      expect(postNamespace.parameters!.first!.name, "body");
      expect(
          postNamespace.parameters!.first!.location, APIParameterLocation.body);
    });

    test("Sample - Reference", () {
      final apiPath = doc!.paths!["/api/"];
      final apiPathGet = apiPath!.operations["get"];
      final response = apiPathGet!.responses!["200"];
      final schema = response!.schema;
      expect(schema!.description, contains("APIVersions lists the"));
      expect(schema.isRequired, ["versions", "serverAddressByClientCIDRs"]);
      expect(
          schema.properties!["serverAddressByClientCIDRs"]!.items!
              .properties!["clientCIDR"]!.description,
          contains("The CIDR"));
    });

    test("Can encode as JSON", () {
      expect(json.encode(doc!.asMap()), isA<String>());
    });
  });
}

String fetchKubernetesExample() {
  const config = "test/specs/kubernetes.json";
  if (!exists(config)) {
    if (!exists(dirname(config))) {
      createDir(dirname(config), recursive: true);
    }

    fetch(
        url:
            'https://raw.githubusercontent.com/kubernetes/kubernetes/f091073b0fb4d3a550e7f182eb5465338c8b7cbf/api/openapi-spec/swagger.json',
//            'https://raw.githubusercontent.com/OAI/OpenAPI-Specification/0f9d3ec7c033fef184ec54e1ffc201b2d61ce023/examples/v2.0/json/petstore.json',
        saveToPath: config);
  }
  return config;
}
