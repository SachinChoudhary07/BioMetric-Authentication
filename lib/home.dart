import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  bool authenticated = false;

  Future<void> _authenticate() async {
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint or Face ID',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      authorized =
          authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: const Text(
                      "Authenticate using your fingerprint instead of your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    child: FloatingActionButton(
                      backgroundColor: Colors.teal,
                      onPressed: _authenticate,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 14.0),
                        child: Text(
                          authenticated
                              ? 'Authentication Success'
                              : "Please Authenticate first!",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
