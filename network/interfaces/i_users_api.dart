import '../frappe/data/user.dart';

abstract class IUsersApi {
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<User> fetchUser(String userEmail);
  Future<List<User>> fetchUsers();
}
