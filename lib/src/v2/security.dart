import 'package:codable/cast.dart' as cast;
import 'package:open_api/src/object.dart';
import 'package:open_api/src/v2/parameter.dart';

/// Represents a OAuth 2.0 security scheme flow in the OpenAPI specification.
enum APISecuritySchemeFlow { implicit, password, application, authorizationCode }

class APISecuritySchemeFlowCodec {
  static APISecuritySchemeFlow decode(String flow) {
    switch (flow) {
      case "accessCode":
        return APISecuritySchemeFlow.authorizationCode;
      case "password":
        return APISecuritySchemeFlow.password;
      case "implicit":
        return APISecuritySchemeFlow.implicit;
      case "application":
        return APISecuritySchemeFlow.application;
    }
    return null;
  }

  static String encode(APISecuritySchemeFlow flow) {
    switch (flow) {
      case APISecuritySchemeFlow.authorizationCode:
        return "accessCode";
      case APISecuritySchemeFlow.password:
        return "password";
      case APISecuritySchemeFlow.implicit:
        return "implicit";
      case APISecuritySchemeFlow.application:
        return "application";
    }
    return null;
  }
}

/// Represents a security scheme in the OpenAPI specification.
class APISecurityScheme extends APIObject {
  APISecurityScheme();

  APISecurityScheme.basic() {
    type = "basic";
  }

  APISecurityScheme.apiKey(this.apiKeyName, this.apiKeyLocation) {
    type = "apiKey";
  }

  APISecurityScheme.oauth2(this.oauthFlow, {this.authorizationURL, this.tokenURL, this.scopes: const {}}) {
    type = "oauth2";
  }

  String type;
  String description;

  // API Key
  String apiKeyName;
  APIParameterLocation apiKeyLocation;

  // Oauth2
  APISecuritySchemeFlow oauthFlow;
  String authorizationURL;
  String tokenURL;
  Map<String, String> scopes;

  bool get isOAuth2 {
    return type == "oauth2";
  }

  @override
  Map<String, cast.Cast> get castMap =>
    {"scopes": cast.Map(cast.String, cast.String)};

  void decode(KeyedArchive object) {
    super.decode(object);

    type = object.decode("type");
    description = object.decode("description");

    if (type == "basic") {
    } else if (type == "oauth2") {
      oauthFlow = APISecuritySchemeFlowCodec.decode(object.decode("flow"));
      authorizationURL = object.decode("authorizationUrl");
      tokenURL = object.decode("tokenUrl");
      scopes = new Map<String, String>.from(object.decode("scopes"));
    } else if (type == "apiKey") {
      apiKeyName = object.decode("name");
      apiKeyLocation = APIParameterLocationCodec.decode(object.decode("in"));
    }
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("type", type);
    object.encode("description", description);

    if (type == "basic") {
      /* nothing to do */
    } else if (type == "apiKey") {
      object.encode("name", apiKeyName);
      object.encode("in", APIParameterLocationCodec.encode(apiKeyLocation));
    } else if (type == "oauth2") {
      object.encode("flow", APISecuritySchemeFlowCodec.encode(oauthFlow));

      object.encode("authorizationUrl", authorizationURL);
      object.encode("tokenUrl", tokenURL);
      object.encode("scopes", scopes);
    }
  }
}
