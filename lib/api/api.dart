import 'dart:convert';

import 'package:mark/common/http.dart';
import 'package:mark/entity/user.dart';

class UserApi {
  static Future login() async {
    var url =
        'https://raw.githubusercontent.com/fangmd/markdownphoto/master/user#';
    var resp = await Http.getDio().get(url, queryParameters: {'userid': '12'});
    return User.fromJson(json.decode(resp.data));
  }
}
