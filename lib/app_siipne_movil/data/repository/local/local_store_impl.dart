part of '../data_repositories.dart';

class LocalStoreImpl extends LocalStorageRepository {
  final LocalStoreProviderImpl _localStoreProviderImpl = Get.find();

  @override
  Future<void> clearAllData() async {
    return _localStoreProviderImpl.clearAllData();
  }

  @override
  Future<Token?> getToken() async {
    return _localStoreProviderImpl.getToken();
  }

  @override
  Future<void> setToken(Token? token) async {
    return _localStoreProviderImpl.setToken(token);
  }

  @override
  Future<void> setUserModel(User user) async {
    return _localStoreProviderImpl.setUserModel(user);
  }

  @override
  Future<User> getUserModel() async {
    return _localStoreProviderImpl.getUserModel();
  }

  @override
  Future<String> getUser() async {
    return _localStoreProviderImpl.getUser();
  }

  @override
  Future<void> setUser(String user) async {
    return _localStoreProviderImpl.setUser(user);
  }

  @override
  Future<Uint8List?> getFoto() async {
    return _localStoreProviderImpl.getFoto();
  }

  @override
  Future<void> setFoto(String? foto) async {
    return _localStoreProviderImpl.setFoto(foto);
  }

  @override
  Future<String> getPass() async {
    return _localStoreProviderImpl.getPass();
  }

  @override
  Future<void> setPass(String pass) async {
    return _localStoreProviderImpl.setPass(pass);
  }

  @override
  Future<String> getUserName() async {
    return _localStoreProviderImpl.getUserName();
  }

  @override
  Future<void> setUserName(String userName) async {
    return _localStoreProviderImpl.setUserName(userName);
  }

  @override
  Future<bool> isDarkMode() async {
    return _localStoreProviderImpl.isDarkMode();
  }

  @override
  Future<void> setDarkMode(bool isThemeDark) async {
    return _localStoreProviderImpl.setDarkMode(isThemeDark);
  }

  @override
  Future<bool> getAppInicial() async {
    return _localStoreProviderImpl.getAppInicial();
  }

  @override
  Future<bool> getConfigHuella() async {
    return _localStoreProviderImpl.getConfigHuella();
  }

  @override
  Future<void> setAppInicial(bool value) async {
    return _localStoreProviderImpl.setAppInicial(value);
  }

  @override
  Future<void> setConfigHuella(bool value) async {
    return _localStoreProviderImpl.setConfigHuella(value);
  }

  //Cuando el usuario a cambiado la clave y al precionar la huella por segunda  vez y no ingresa tiene que reiniciarse
  //para que se loguee con su nueva cuenta
  @override
  Future<int> getContadorFallido() async {
    return _localStoreProviderImpl.getContadorFallido();
  }

  @override
  Future<void> setContadorFallido(int value) async {
    return _localStoreProviderImpl.setContadorFallido(value);
  }

  @override
  Future<String> getPinCode() async {
    return await _localStoreProviderImpl.getPinCode();
  }

  @override
  Future<void> setPinCode(String value) async {
    return await _localStoreProviderImpl.setPinCode(value);
  }
}
