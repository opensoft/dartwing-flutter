import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/folder_response.dart';
import 'data/organization.dart';
import 'data/provider.dart';
import 'data/user.dart';

class DartWingApi extends BaseNetworkApi {
  DartWingApi(RestClient restClient, String host, String location)
      : super(restClient, host, location);

  Future<User> fetchUser() async {
    return await RestClient.get(Uri.parse('$host/api/user'),
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

  Future<List<String>> fetchOrganizations() async {
    return await RestClient.get(Uri.parse('$host/api/user/companies'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch organizations/companies');
      }
      var jsonArray = json.decode(response.body);
      List<String> companies = [];
      for (var object in jsonArray) {
        companies.add(object['companyName']);
      }

      return companies;
    });
  }

  Future<Organization> fetchOrganization(String name) async {
    return await RestClient.get(Uri.parse('$host/api/company/$name'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch organization');
      }
      return Organization.fromJson(json.decode(response.body));
    });
  }

  Future<Organization> createOrganization(Organization organization) async {
    return await RestClient.post(Uri.parse('$host/api/company'),
            headers: createUmsAuthNetworkHeaders(),
            body: jsonEncode(organization.toJson()))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create or update organization');
      }
      return Organization.fromJson(json.decode(response.body));
    });
  }

  Future<List<Provider>> fetchOrganizationProviders(String name) async {
    return await RestClient.get(Uri.parse('$host/api/company/$name/providers'),
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

  Future<FolderResponse> fetchFolders(String provider, String company) async {
    Map<String, dynamic> body = {'provider': provider};
    return await RestClient.post(Uri.parse("$host/api/files/$company/folders"),
            headers: createUmsAuthNetworkHeaders(), body: jsonEncode(body))
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response,
            'Cannot get folders for provider $provider and company $company');
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
