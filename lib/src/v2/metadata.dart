import 'package:open_api/src/object.dart';

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

  void decode(KeyedArchive object) {
    super.decode(object);

    title = object.decode("title");
    description = object.decode("description");
    termsOfServiceURL = object.decode("termsOfService");
    contact = object.decodeObject("contact", () => new APIContact());
    license = object.decodeObject("license", () => new APILicense());
    version = object.decode("version");
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("title", title);
    object.encode("description", description);
    object.encode("version", version);
    object.encode("termsOfService", termsOfServiceURL);
    object.encodeObject("contact", contact);
    object.encodeObject("license", license);
  }
}

/// Represents contact information in the OpenAPI specification.
class APIContact extends APIObject {
  APIContact();

  void decode(KeyedArchive object) {
    super.decode(object);

    name = object.decode("name");
    url = object.decode("url");
    email = object.decode("email");
  }

  String name = "default";
  String url = "http://localhost";
  String email = "default";

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("name", name);
    object.encode("url", url);
    object.encode("email", email);
  }
}

/// Represents a copyright/open source license in the OpenAPI specification.
class APILicense extends APIObject {
  APILicense();

  void decode(KeyedArchive object) {
    super.decode(object);

    name = object.decode("name");
    url = object.decode("url");
  }

  String name = "default";
  String url = "http://localhost";

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("name", name);
    object.encode("url", url);
  }
}

class APITag extends APIObject {
  APITag();

  void decode(KeyedArchive object) {
    super.decode(object);

    name = object.decode("name");
    description = object.decode("description");
  }

  String name;
  String description;

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("name", name);
    object.encode("description", description);
  }
}
