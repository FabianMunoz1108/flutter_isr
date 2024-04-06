import 'package:flutter/services.dart';

final decimalInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'));