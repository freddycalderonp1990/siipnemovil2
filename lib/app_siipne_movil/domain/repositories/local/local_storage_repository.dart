//Para Guardar informacion en local

part of '../domain_repositories.dart';
abstract class LocalStorageRepository{
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<Token?> getToken();
  Future<void> setToken(Token? token);

  Future<User> getUserModel();
  Future<void> setUserModel(User user);



  Future<int> getContadorFallido();
  Future<void> setContadorFallido(int value);

  Future<bool> getAppInicial();
  Future<void> setAppInicial(bool value);

 Future<bool> getConfigHuella() ;
  Future<void> setConfigHuella(bool value) ;



  Future<void> setUser(String user);
  Future<String> getUser();

  Future<void> setPass(String pass);
  Future<String> getPass();

  Future<void> setFoto(String? foto);
  Future<Uint8List?> getFoto();

  Future<void> setUserName(String userName);
  Future<String> getUserName();

  Future<void> setDarkMode(bool isThemeDark);
  Future<bool> isDarkMode();

  Future<void> setPinCode(String value);
  Future<String> getPinCode();


  Future<void> clearAllData();

}