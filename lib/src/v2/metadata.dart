import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';

/// Represents a metadata for an API in the OpenAPI specification.
class APIInfo extends APIObject {
  /// Creates empty metadata for specification.
  APIInfo();

  String title = "API";
  String description = "Description";
  String version = "1.0";
  String termsOfServiceURL = "";
  APIContact contact = new APIContact();
  APILicense license = new APILicense();

  void decode(JSONObject json) {
    title = json.decode("title") ?? "Untitled";
    description = json.decode("description");
    termsOfServiceURL = json.decode("termsOfService");
    contact = json.decode("contact", inflate: () => new APIContact());
    license = json.decode("license", inflate: () => new APILicense());
    version = json.decode("version") ?? "1.0.0";
  }

  void encode(JSONObject object) {
    object.encode("title", title);
    object.encode("desription", description);
    object.encode("version", version);
    object.encode("termsOfService", termsOfServiceURL);
    object.encodeObject("contact", contact);
    object.encodeObject("license", license);
  }
}

/// Represents contact information in the OpenAPI specification.
class APIContact extends APIObject {
  APIContact();

  void decode(JSONObject json) {
    name = json.decode("name");
    url = json.decode("url");
    email = json.decode("email");
  }

  String name = "default";
  String url = "http://localhost";
  String email = "default";

  void encode(JSONObject object) {
    object.encode("name", name);
    object.encode("url", url);
    object.encode("email", email);
  }
}

/// Represents a copyright/open source license in the OpenAPI specification.
class APILicense extends APIObject {
  APILicense();
  void decode(JSONObject json) {
    name = json.decode("name");
    url = json.decode("url");
  }

  String name = "default";
  String url = "http://localhost";

  void encode(JSONObject object) {
    object.encode("name", name);
    object.encode("url", url);
  }
}

class APITag extends APIObject {
  APITag();

  void decode(JSONObject json) {
    name = json.decode("name");
    description = json.decode("description");
  }

  String name;
  String description;

  void encode(JSONObject object) {
    object.encode("name", name);
    object.encode("description", description);
  }
}