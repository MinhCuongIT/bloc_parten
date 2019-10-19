import 'package:bloc_parten/user.dart';

class Repository {
  Future<User> getUser() async {
    await Future.delayed(Duration(seconds: 2));
    return User(name: 'John', surname: 'Smith');
  }
}