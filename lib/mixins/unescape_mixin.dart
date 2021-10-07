import 'package:html_unescape/html_unescape_small.dart';

HtmlUnescape unescapeHtml = HtmlUnescape();

String unescape(dynamic data) {
  if (data is String) {
    return unescapeHtml.convert(data);
  }
  return '';
}

class UnescapeMixin {
  String unescape(dynamic data) => unescape(data);
}
