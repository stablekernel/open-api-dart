# Changelog

## 3.0.0+4

- Remove forced null unwraps.

## 3.0.0+3

- fix header parameters, update dependency on codable.

## 3.0.0+2

- Rename APISchemaObject.isRequired back to required

## 3.0.0

- nullsafety migration

## 2.0.1+1

- forked version to fix v3 security requirements

## 2.0.1

- Fix bug when merging APIResponse bodies

# 2.0.0

- Update for Dart 2

## 1.0.2

- Adds `APIResponse.addHeader` and `APIResponse.addContent`.
- Adds `APIOperation.addResponse`.

## 1.0.1 

- Adds `APISchemaObject.isFreeForm` and related support for free-form schema objects.

## 1.0.0

- Adds support for OpenAPI 3.0
- Splits Swagger (2.0) and OpenAPI (3.0) into 'package:open_api/v2.dart' and 'package:open_api/v3.dart'.

## 0.9.1

- Moves shared properties from `APISchema`, `APIHeader` and `APIParameter` into `APIProperty`.

## 0.9.0

- Initial data structures
- Parsing specifications
- Writing specifications to disk
