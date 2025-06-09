class ApiConfig {
  static const String baseUrl = _androidEmulator;

  static const String _webLocal = "http://127.0.0.1:8081/api/v1/hidden_pass";
  static const String _androidEmulator =
      "http://10.0.2.2:8081/api/v1/hidden_pass";
  static const String _prodLocal =
      "http://192.168.1.8:8081/api/v1/hidden_pass"; //CAMBIAR POR TU IP
  static const String _prod =
      "https://hidden-pass-api-rest.onrender.com/api/v1/hidden_pass";

  static String endpoint(String path) => "$baseUrl$path";
}
