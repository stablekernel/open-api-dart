import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';
import 'package:open_api/src/v3/parameter.dart';

/// Represents a OAuth 2.0 security scheme flow in the OpenAPI specification.
enum APISecuritySchemeFlow {
  implicit,
  password,
  clientCredentials,
  authorizationCode
}

class APISecuritySchemeFlowCodec {
  static APISecuritySchemeFlow decode(String flow) {
    switch (flow) {
      case "authorizationCode":
        return APISecuritySchemeFlow.authorizationCode;
      case "password":
        return APISecuritySchemeFlow.password;
      case "implicit":
        return APISecuritySchemeFlow.implicit;
      case "clientCredentials":
        return APISecuritySchemeFlow.clientCredentials;
    }
    return null;
  }

  static String encode(APISecuritySchemeFlow flow) {
    switch (flow) {
      case APISecuritySchemeFlow.authorizationCode:
        return "authorizationCode";
      case APISecuritySchemeFlow.password:
        return "password";
      case APISecuritySchemeFlow.implicit:
        return "implicit";
      case APISecuritySchemeFlow.clientCredentials:
        return "clientCredentials";
    }
    return null;
  }
}

enum APISecuritySchemeType { apiKey, http, oauth2, openID }

class APISecuritySchemeTypeCodec {
  static APISecuritySchemeType decode(String type) {
    switch (type) {
      case "apiKey":
        return APISecuritySchemeType.apiKey;
      case "http":
        return APISecuritySchemeType.http;
      case "oauth2":
        return APISecuritySchemeType.oauth2;
      case "openID":
        return APISecuritySchemeType.openID;
    }
    return null;
  }

  static String encode(APISecuritySchemeType type) {
    switch (type) {
      case APISecuritySchemeType.apiKey:
        return "apiKey";
      case APISecuritySchemeType.http:
        return "http";
      case APISecuritySchemeType.oauth2:
        return "oauth2";
      case APISecuritySchemeType.openID:
        return "openID";
    }
    return null;
  }
}

/// Represents a security scheme in the OpenAPI specification.
class APISecurityScheme extends APIObject {
  APISecurityScheme();

  APISecurityScheme.http() : type = APISecuritySchemeType.http;

  APISecurityScheme.apiKey(this.name, this.location)
      : type = APISecuritySchemeType.apiKey;

  APISecurityScheme.oauth2(Map) : type = APISecuritySchemeType.oauth2;

  APISecurityScheme.openID(this.connectURL)
      : type = APISecuritySchemeType.openID;

  APISecuritySchemeType type;
  String description;

  /// For apiKey only
  String name;

  /// For apiKey only
  APIParameterLocation location;

  /// For http only
  String scheme;

  /// For http only
  String format;

  /// For oauth2 only
  Map<String, APISecuritySchemeOAuth2Flow> flows = {};

  /// For openID only
  Uri connectURL;

  void decode(JSONObject object) {
    super.decode(object);

    type = object.decode("type");
    description = object.decode("description");

    switch (type) {
      case APISecuritySchemeType.apiKey:
        {
          name = object.decode("name");
          location = APIParameterLocationCodec.decode(object.decode("in"));
        }
        break;
      case APISecuritySchemeType.oauth2:
        {
          flows = object.decodeObjectMap(
              "flows", () => new APISecuritySchemeOAuth2Flow());
        }
        break;
      case APISecuritySchemeType.http:
        {
          scheme = object.decode("scheme");
          format = object.decode("bearerFormat");
        }
        break;
      case APISecuritySchemeType.openID:
        {
          connectURL = object.decodeUri("openIdConnectUrl");
        }
        break;
    }
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("type", type);
    object.encode("description", description);

    switch (type) {
      case APISecuritySchemeType.apiKey:
        {
          object.encode("name", name);
          object.encode("in", APIParameterLocationCodec.encode(location));
        }
        break;
      case APISecuritySchemeType.oauth2:
        {
          object.encodeObjectMap("flows", flows);
        }
        break;
      case APISecuritySchemeType.http:
        {
          object.encode("scheme", scheme);
          object.encode("bearerFormat", format);
        }
        break;
      case APISecuritySchemeType.openID:
        {
          object.encodeUri("openIdConnectUrl", connectURL);
        }
        break;
    }
  }
}

class APISecuritySchemeOAuth2Flow extends APIObject {
  Uri authorizationURL;
  Uri tokenURL;
  Uri refreshURL;
  Map<String, String> scopes;

  void encode(JSONObject object) {
    super.encode(object);

    object.encodeUri("authorizationUrl", authorizationURL);
    object.encodeUri("tokenUrl", tokenURL);
    object.encodeUri("refreshUrl", refreshURL);
    object.encode("scopes", scopes);
  }

  void decode(JSONObject object) {
    super.decode(object);

    authorizationURL = object.decodeUri("authorizationUrl");

    tokenURL = object.decodeUri("tokenUrl");
    refreshURL = object.decodeUri("refreshUrl");

    scopes = object.decode("scopes");
  }
}
