# open_api_dart

Reads and writes OpenAPI (Swagger) specifications.

Example
---

```dart
final file = File("test/specs/kubernetes.json");
final contents = await file.readAsString();
final doc = APIDocument.fromJSON(contents);

final output = JSON.encode(doc.asMap());
```

