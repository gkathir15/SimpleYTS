import 'dart:convert';

class commonHelper{



  static prettyPrint(String data)
  {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    print(encoder.convert(json.decode(data)));
  }

}