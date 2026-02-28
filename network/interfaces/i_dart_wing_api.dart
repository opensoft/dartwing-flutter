import '../dart_wing/data/address.dart';
import '../dart_wing/data/folder_response.dart';
import '../dart_wing/data/organization.dart';
import '../dart_wing/data/provider.dart';
import '../dart_wing/data/site_status_reply.dart';
import '../dart_wing/data/user.dart';

abstract class IDartWingApi {
  Future<User> fetchUser();
  Future<User> createUser(User user);
  Future<List<Organization>> fetchOrganizations();
  Future<Organization> fetchOrganization(String companyName);
  Future<Organization> createOrganization(Organization organization);
  Future<String> fetchOrganizationPath(String companyName);
  Future<dynamic> saveOrganizationPath(String companyName, String path);
  Future<Address> fetchOrganizationAddress(String companyName);
  Future<void> saveOrganizationAddress(String companyName, Address address);
  Future<List<Provider>> fetchOrganizationProviders(String name);
  Future<String> createSite(
    String companyName,
    String abbreviation,
    Address address,
    String documentUploadMethod,
  );
  Future<SiteStatusReply> fetchSiteStatus();
  Future<FolderResponse> fetchFolders(
    String provider,
    String company,
    String folderPath,
  );
  Future<void> saveFolderPath(
    String provider,
    String folderPath,
    String company,
  );
  Future<void> uploadFile(
    String company,
    List<int> file, {
    String filename,
  });
  Future<void> sendInvitationByEmail(
    String email,
    String userName,
    String company,
  );
  Future<Organization> verifyInvitation(
    String verificationCode,
    bool accepted,
  );
}
