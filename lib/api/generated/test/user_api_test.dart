import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserApi
void main() {
  final instance = Openapi().getUserApi();

  group(UserApi, () {
    // Create user.
    //
    // This can only be done by the logged in user.
    //
    //Future<User> createUser({ User user }) async
    test('test createUser', () async {
      // TODO
    });

    // Creates list of users with given input array.
    //
    // Creates list of users with given input array.
    //
    //Future<User> createUsersWithListInput({ BuiltList<User> user }) async
    test('test createUsersWithListInput', () async {
      // TODO
    });

    // Delete user resource.
    //
    // This can only be done by the logged in user.
    //
    //Future deleteUser(String username) async
    test('test deleteUser', () async {
      // TODO
    });

    // Get user by user name.
    //
    // Get user detail based on username.
    //
    //Future<User> getUserByName(String username) async
    test('test getUserByName', () async {
      // TODO
    });

    // Logs user into the system.
    //
    // Log into the system.
    //
    //Future<String> loginUser({ String username, String password }) async
    test('test loginUser', () async {
      // TODO
    });

    // Logs out current logged in user session.
    //
    // Log user out of the system.
    //
    //Future logoutUser() async
    test('test logoutUser', () async {
      // TODO
    });

    // Update user resource.
    //
    // This can only be done by the logged in user.
    //
    //Future updateUser(String username, { User user }) async
    test('test updateUser', () async {
      // TODO
    });

  });
}
