import 'dart:convert';
import 'package:flutter_proyecto_isr/models/rango_isr.dart';
import 'package:http/http.dart' as http;

class ISRService {
  final String _baseUrl = 'http://localhost:8888';

  Future<List<RangoIsr>> getRangosIsr() async {
    final response = await http.get(Uri.parse('$_baseUrl/isr'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      //List<RangoIsr> lista = data.map((dynamic item) => RangoIsr.fromJson(item)).toList();

      return data.map((json) => RangoIsr.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los rangos del ISR');
    }
  }

  
  Future<RangoIsr> getRangoIsr(double salario) async {
    final response = await http.get(Uri.parse('$_baseUrl/isr/$salario'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return RangoIsr.fromJson(data);
    } else {
      throw Exception('Error al obtener el rango del ISR: $salario');
    }
  }
}
