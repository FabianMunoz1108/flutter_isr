class RangoIsr{
  double limiteInferior;
  double limiteSuperior;
  double cuotaFija;
  double porcentaje;

  RangoIsr({
    required this.limiteInferior, 
    required this.limiteSuperior, 
    required this.cuotaFija, 
    required this.porcentaje});

  bool estaDentroDelRango(double salario){
    return salario >= limiteInferior && salario <= limiteSuperior;
  }
  double calcularImpuesto(double ingreso){
    if(estaDentroDelRango(ingreso)){
      return cuotaFija + ((ingreso - limiteInferior) * (porcentaje / 100));
    }
    return 0.0;
  }

  factory RangoIsr.fromJson(Map<String, dynamic> json){
    return RangoIsr(
      limiteInferior: json['limiteInferior'],
      limiteSuperior: json['limiteSuperior'],
      cuotaFija: json['cuotaFija'],
      porcentaje: json['porcentaje']
    );
  }
}