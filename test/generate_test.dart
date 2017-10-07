// Copyright (c) 2017, joeconway. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:open_api/open_api.dart';
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
      original = JSON.decode(contents);
      doc = new APIDocument.fromJSON(contents);
    });

    test("ok", () {
      var gen = new Generator("dart", doc, definitionNamer: (s) => s.split(".").last);
      print("${gen.fileSources}");
    });
  });
}
