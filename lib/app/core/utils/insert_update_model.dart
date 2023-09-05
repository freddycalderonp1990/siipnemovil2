

import 'dart:convert';

import 'parse_model.dart';



class InserUpdateModel {
  InserUpdateModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  factory InserUpdateModel.fromJson(String str, String nameCampo) =>
      InserUpdateModel.fromMap(json.decode(str), nameCampo);

  factory InserUpdateModel.fromMap(Map<String, dynamic> jsonData, String nameCampo) {

    bool success=jsonData["success"] == null ? false : jsonData["success"];


    return InserUpdateModel(
      success:success,
      statusCode: ParseModel.parseToInt(jsonData["status_code"]),
      message:ParseModel.parseToString(jsonData["message"]),
      data:  success?     Data(id:jsonData["data"][nameCampo] != null ? ParseModel.parseToInt(jsonData["data"][nameCampo]) : 0):Data(id: 0),
    );
  }
}

class Data {
  Data({
    required this.id,
  });

  final int id;

}
