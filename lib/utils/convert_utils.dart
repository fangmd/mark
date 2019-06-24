bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

double converStrToDouble(dynamic s) {
  s = s.toString();
  if (s == null) {
    return 0.00;
  }
  var ret = double.tryParse(s);
  if (ret == null) {
    ret = 0.00;
  }
  print(ret.toString());
  return ret;
}

String formatDouble(double n) {
  var num = n.truncateToDouble() == n ? 0: 2;
  return n.toStringAsFixed(num);
}
