import 'package:bloc_parten/repository.dart';
import 'package:bloc_parten/user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
class UserModelScreen extends StatefulWidget {
  UserModelScreen(this._repository);
  final Repository _repository;

  @override
  State<StatefulWidget> createState() => _UserModelScreenState();
}

class _UserModelScreenState extends State<UserModelScreen> {
  UserModel _userModel;

  @override
  void initState() {
    _userModel = UserModel(widget._repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _userModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scoped model'),
        ),
        body: SafeArea(
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return _buildLoading();
              } else {
                if (model.user != null) {
                  return _buildContent(model);
                } else {
                  return _buildInit(model);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInit(UserModel userModel) {
    return Center(
      child: RaisedButton(
        child: const Text('Load user data'),
        onPressed: () {
          userModel.loadUserData();
        },
      ),
    );
  }

  Widget _buildContent(UserModel userModel) {
    return Center(
      child: Text('Hello ${userModel.user.name} ${userModel.user.surname}'),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class UserModel extends Model {
  UserModel(this._repository);
  final Repository _repository;

  bool _isLoading = false;
  User _user;

  User get user => _user;
  bool get isLoading => _isLoading;

  void loadUserData() {
    _isLoading = true;
    notifyListeners();
    _repository.getUser().then((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);
}