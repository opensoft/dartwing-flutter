import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'dart_wing_api_helper.dart';
import 'data/folder_response.dart';
import 'data/organization.dart';
import 'data/provider.dart';
import 'data/user.dart';

class DartWingApi extends BaseNetworkApi {
  DartWingApi(RestClient restClient, String host, String location)
      : super(restClient, host, location);

  Future<User> fetchUser() async {
    return await RestClient.get(Uri.parse('$host/api/user/me'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<User> createUser(User user) async {
    return await RestClient.post(Uri.parse('$host/api/user'),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(user.toJson()))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create or update user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<List<Organization>> fetchOrganizations() async {
    return await RestClient.get(Uri.parse('$host/api/user/me/company'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch organizations/companies');
      }
      var jsonArray = json.decode(response.body)['companies'];
      List<Organization> companies = [];
      for (var object in jsonArray) {
        companies.add(Organization.fromJson(object));
      }
      return companies;
    });
  }

  Future<Organization> fetchOrganization(String companyName) async {
    return await RestClient.get(
            Uri.parse('$host/api/company/$location/$companyName'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(
            response, 'Cannot fetch organization $companyName in $location');
      }
      return Organization.fromJson(json.decode(response.body));
    });
  }

  Future<Organization> createOrganization(Organization organization) async {
    return await RestClient.post(
            Uri.parse('$host/api/company/${organization.frappeSiteUrl}'),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(organization.toJson()))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create or update organization');
      }
      return Organization.fromJson(json.decode(response.body));
    });
  }

  Future<String> fetchOrganizationPath(String companyName) async {
    return await RestClient.get(
            Uri.parse('$host/api/company/$location/$companyName/path'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response,
            'Cannot fetch organization path $companyName in $location');
      }
      return json.decode(response.body)['path'];
    });
  }

  Future saveOrganizationPath(String companyName, String path) async {
    Map<String, dynamic> body = {'path': path};
    return await RestClient.post(
            Uri.parse('$host/api/company/$location/$companyName/path'),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(body))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create or update organization');
      }
    });
  }

  Future<List<Provider>> fetchOrganizationProviders(String name) async {
    return await RestClient.get(
            Uri.parse('$host/api/company/$location/$name/providers'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch organization providers');
      }

      var jsonArray = json.decode(response.body)['providers'];
      List<Provider> providers = [];
      for (var object in jsonArray) {
        providers.add(Provider.fromJson(object));
      }

      return providers;
    });
  }

  Future<String> createSite(
      String siteName, String companyName, String companyFullName) async {
    Map<String, dynamic> body = {
      'siteName': siteName,
      'companyName': companyName,
      'companyFullName': companyFullName
    };
    return await RestClient.post(Uri.parse('$host/api/site'),
            headers: createUmsAuthNetworkHeaders(), body: jsonEncode(body))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create site $siteName');
      }
      return json.decode(response.body)['site'].toString();
    });
  }

  Future<SiteStatus> fetchSiteStatus() async {
    return await RestClient.get(Uri.parse('$host/api/site/$location'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch site status for $location');
      }
      String status = json.decode(response.body)['status'].toLowerCase();
      return SiteStatus.values
          .firstWhere((e) => e.name.toLowerCase() == status);
    });
  }

  Future<FolderResponse> fetchFolders(
      String provider, String company, String folderPath) async {
    Map<String, dynamic> body = {
      'provider': provider,
      'folderPath': folderPath
    };
    return await RestClient.post(
            Uri.parse("$host/api/file/$location/$company/userfolders"),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(body))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response,
            'Cannot get folders for provider $provider and company $company, path $folderPath');
      }
      return FolderResponse.fromJson(json.decode(response.body));
    });
  }

  Future<void> saveFolderPath(
      String provider, String folderPath, String company) async {
    Map<String, dynamic> body = {
      'provider': provider,
      'folderPath': folderPath
    };
    return await RestClient.post(
            Uri.parse("$host/api/files/$company/folders/save"),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(body))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response,
            'Cannot save folderPath $folderPath for provider $provider and company $company');
      }
    });
  }

  Future<void> uploadFile(String company, List<int> file,
      {String filename = "file"}) async {
    Map<String, String> fieldParam = {};
    Map<String, List<int>> files = {'file': file};
    return await RestClient.multipartFileRequest(
            Uri.parse("$host/api/files/$company/upload"),
            fieldParam,
            files,
            filename,
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode != 200) {
        errorHandler(response,
            'Cannot upload document (size ${file.length}) to company $company');
      }
    });
  }
}
