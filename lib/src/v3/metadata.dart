import 'package:open_api/src/json_object.dart';
import 'package:open_api/src/util.dart';

/// The object provides metadata about the API.
///
/// The metadata MAY be used by the clients if needed, and MAY be presented in editing or documentation generation tools for convenience.
class APIInfo extends APIObject {
  /// Creates empty metadata for specification.
  APIInfo();

  /// The title of the application.
  ///
  /// REQUIRED.
  String title = "Default";

  /// A short description of the application.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  /// The version of the OpenAPI document (which is distinct from the OpenAPI Specification version or the API implementation version).
  ///
  /// REQUIRED.
  String version = "1.0";

  /// A URL to the Terms of Service for the API.
  ///
  /// MUST be in the format of a URL.
  Uri termsOfServiceURL;

  /// The contact information for the exposed API.
  APIContact contact = new APIContact();

  /// The license information for the exposed API.
  APILicense license = new APILicense();

  void decode(JSONObject object) {
    super.decode(object);

    title = object.decode("title");
    description = object.decode("description");
    termsOfServiceURL = object.decodeUri("termsOfService");
    contact = object.decode("contact", inflate: () => new APIContact());
    license = object.decode("license", inflate: () => new APILicense());
    version = object.decode("version");
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (title == null || version == null) {
      throw new APIException("APIInfo must have non-null values for: 'title', 'version'.");
    }

    object.encode("title", title);
    object.encode("description", description);
    object.encode("version", version);
    object.encodeUri("termsOfService", termsOfServiceURL);
    object.encodeObject("contact", contact);
    object.encodeObject("license", license);
  }
}

/// Contact information for the exposed API.
class APIContact extends APIObject {
  APIContact();

  /// The identifying name of the contact person/organization.
  String name;

  /// The URL pointing to the contact information.
  ///
  /// MUST be in the format of a URL.
  Uri url;

  /// The email address of the contact person/organization.
  ///
  /// MUST be in the format of an email address.
  String email;

  void decode(JSONObject object) {
    super.decode(object);

    name = object.decode("name");
    url = object.decodeUri("url");
    email = object.decode("email");
  }

  void encode(JSONObject object) {
    super.encode(object);

    object.encode("name", name);
    object.encodeUri("url", url);
    object.encode("email", email);
  }
}

/// License information for the exposed API.
class APILicense extends APIObject {
  APILicense();

  /// The license name used for the API.
  ///
  /// REQUIRED.
  String name;

  /// A URL to the license used for the API.
  ///
  /// MUST be in the format of a URL.
  Uri url;

  void decode(JSONObject object) {
    super.decode(object);

    name = object.decode("name");
    url = object.decodeUri("url");
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (name == null) {
      throw new APIException("APILicense must have non-null values for: 'name'.");
    }

    object.encode("name", name);
    object.encodeUri("url", url);
  }
}

/// Adds metadata to a single tag that is used by the [APIOperation].
///
/// It is not mandatory to have a [APITag] per tag defined in the [APIOperation] instances.
class APITag extends APIObject {
  APITag();

  /// The name of the tag.
  ///
  /// REQUIRED.
  String name;

  /// A short description for the tag.
  ///
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  void decode(JSONObject object) {
    super.decode(object);

    name = object.decode("name");
    description = object.decode("description");
  }

  void encode(JSONObject object) {
    super.encode(object);

    if (name == null) {
      throw new APIException("APITag must have non-null values for: 'name'.");
    }
    object.encode("name", name);
    object.encode("description", description);
  }
}
