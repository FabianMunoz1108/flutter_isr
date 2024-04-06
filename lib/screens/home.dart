import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_isr/models/rango_isr.dart';
import 'package:flutter_proyecto_isr/services/isr_service.dart';
//import 'package:flutter_proyecto_isr/utils/constants.dart';
import 'package:flutter_proyecto_isr/utils/input_formatters.dart';
import 'package:intl/intl.dart';

class HomeIsr extends StatefulWidget {
  const HomeIsr({super.key});

  @override
  State<HomeIsr> createState() => _HomeIsrState();
}

class _HomeIsrState extends State<HomeIsr> {
  final _ingresoController = TextEditingController();
  double _impuestoCalculado = 0.0;
  RangoIsr? _rangoIsrSeleccionado;

  List<RangoIsr> _rangos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRangosIsrAsync();
  }

  void _cargarRangosIsrAsync() async {
    final service = ISRService();

    try {
      final rangos = await service.getRangosIsr();

      setState(() {
        _rangos = rangos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _calularIsrAsync() async {
    final ingreso = double.tryParse(_ingresoController.text) ?? 0.0;
    final service = ISRService();

    try {
      final rango = await service.getRangoIsr(ingreso);

      setState(() {
        _impuestoCalculado = rango.calcularImpuesto(ingreso);
        _rangoIsrSeleccionado = rango;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

/*
  void calcularIsr() {
    final ingreso = double.tryParse(_ingresoController.text) ?? 0.0;

    for (var rango in rangoIsr) {
      if (rango.estaDentroDelRango(ingreso)) {
        setState(() {
          _impuestoCalculado = rango.calcularImpuesto(ingreso);
          _rangoIsrSeleccionado = rango;
        });
        return;
        //break;
      }
    }

    /*final rango = rangoIsr.firstWhere((rango) => rango.estaDentroDelRango(ingreso));
    final impuesto = rango.calcularImpuesto(ingreso);
    setState(() {
      _impuestoCalculado = impuesto;
      _rangoIsrSeleccionado = rango;
    });*/
  }
*/
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Calculadora de ISR'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: CupertinoTextField(
                      placeholder: 'Ingreso',
                      controller: _ingresoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [decimalInputFormatter],
                    )),
                    const SizedBox(width: 8.0),
                    CupertinoButton(
                      onPressed: _calularIsrAsync,
                      child: const Icon(CupertinoIcons.doc),
                    ),
                  ],
                ),
                const Divider(
                  height: 2,
                ),
                if (_isLoading)
                  const Center(child: CupertinoActivityIndicator()),
                if (!_isLoading) ...[
                  Expanded(
                    child: ListView.builder(
                        itemCount: _rangos.length,
                        itemBuilder: (context, index) {
                          return CupertinoListTile(
                            backgroundColor: _rangos[index].limiteInferior ==
                                    _rangoIsrSeleccionado?.limiteInferior
                                ? CupertinoColors.lightBackgroundGray
                                : null,
                            title: Text(
                                'De ${NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(_rangos[index].limiteInferior)}'
                                ' a ${NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(_rangos[index].limiteSuperior)}'),
                            subtitle: Text(
                                'Cuota fija: ${NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(_rangos[index].cuotaFija)}'
                                ' , Porcentaje excedente: ${_rangos[index].porcentaje}%'),
                          );
                        }),
                  ),
                  const Divider(height: 2),
                  const SizedBox(height: 8.0),
                  Text(
                      'ISR a pagar: ${NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(_impuestoCalculado)}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold))
                ],
              ],
            ),
          ),
        ));
  }
}