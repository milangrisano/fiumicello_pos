import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Usamos un Singleton para poder leer este estado desde app_router.dart 
  // (que es una variable global) de forma limpia sin depender de un `context`.
  static final AuthProvider instance = AuthProvider._internal();
  
  AuthProvider._internal();

  // Simulación de la persistencia del JWT
  String? _jwtToken;

  // Getter para saber si hay sesión activa (token existe)
  bool get isAuthenticated => _jwtToken != null;

  // Simulamos la validación del Token contra el backend
  Future<bool> verifyTokenWithBackend() async {
    // TODO: Reemplazar con tu petición real (ej. HTTP POST /verify-token)
    // await Future.delayed(const Duration(milliseconds: 500));
    
    // Asumimos que si hay token, el backend responde que es válido
    // En la vida real, si el backend dice "inválido", harías `logout()` o `_jwtToken = null;`
    return _jwtToken != null;
  }

  // Método de prueba: Login (Simula recibir un JWT del Backend)
  void login(String token) {
    _jwtToken = token;
    notifyListeners(); // Esto le avisa a GoRouter y a la UI que recalculen todo
  }

  // Método de prueba: Logout (Borra el JWT)
  void logout() {
    _jwtToken = null;
    notifyListeners();
  }
}
