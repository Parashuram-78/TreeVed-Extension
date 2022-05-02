import 'dart:convert';

class TextwithEmoji {
  static String text({required String value}) {
    final text =  utf8.decode(  value.codeUnits);

    return text;

  }
}
