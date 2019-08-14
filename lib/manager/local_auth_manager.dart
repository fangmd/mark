import 'package:flutter/services.dart';
import 'package:mark/utils/sp_utils.dart';
import 'package:local_auth/local_auth.dart';

import '../C.dart';

class LocalAuthManager {
  final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> getLocalAuthState() async {
    bool ret = await SPUtils.getBool(SP_LOCAL_AUTH);
    return ret;
  }

  static setLocalAuthState(bool state) async {
    await SPUtils.setBool(SP_LOCAL_AUTH, state);
  }

  Future<bool> isBiometricAvaiable() async {
    return await auth.canCheckBiometrics;
  }

  Future<bool> startAuth() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: '解锁 App',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
    return authenticated;
  }
}
