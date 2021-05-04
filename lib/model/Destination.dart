import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Destiantion {
  final String adr;

  Destiantion({@required this.adr});

  factory Destiantion.fromJson(Map<String, dynamic> json) {
    return Destiantion(adr: json['adr']);
  }
  Map<String, dynamic> toJson() => {
        'adr': adr,  
      };
}
