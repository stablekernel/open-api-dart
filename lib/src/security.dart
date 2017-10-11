import 'parameter.dart';
import 'util.dart';
import 'json_object.dart';

/// Represents a OAuth 2.0 security scheme flow in the OpenAPI specification.
enum APISecuritySchemeFlow {
  implicit,
  password,
  application,
  authorizationCode
}

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

  APISecurityScheme.oauth2(this.oauthFlow,
      {this.authorizationURL, this.tokenURL, this.scopes: const {}}) {
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

  void decode(JSONObject json) {
    type = json.decode("type");
    description = json.decode("description");

    if (type == "basic") {

    } else if (type == "oauth2") {
      oauthFlow = APISecuritySchemeFlowCodec.decode(json.decode("flow"));
      authorizationURL = json.decode("authorizationUrl");
      tokenURL = json.decode("tokenUrl");
      scopes = json.decode("scopes");
    } else if (type == "apiKey") {
      apiKeyName = json.decode("name");
      apiKeyLocation = APIParameterLocationCodec.decode(json.decode("in"));
    }
  }

  void encode(JSONObject json) {
    json.encode("type", type);
    json.encode("description", description);

    if (type == "basic") {
      /* nothing to do */
    } else if (type == "apiKey") {
      json.encode("name", apiKeyName);
      json.encode("in", APIParameterLocationCodec.encode(apiKeyLocation));
    } else if (type == "oauth2") {
      json.encode("flow", APISecuritySchemeFlowCodec.encode(oauthFlow));

      json.encode("authorizationUrl", authorizationURL);
      json.encode("tokenUrl", tokenURL);
      json.encode("scopes", scopes);
    }
  }
}