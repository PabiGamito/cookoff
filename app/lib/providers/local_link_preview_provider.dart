import 'package:cookoff/providers/link_preview_provider.dart';
import 'package:link_preview/link_preview.dart';

class LocalLinkPreviewProvider implements LinkPreviewProvider {

  static final LocalLinkPreviewProvider instance = LocalLinkPreviewProvider
      ._internal();
  final LinkPreview preview = LinkPreview();
  final Map<String, Map<String, dynamic>> _cache = {};

  LocalLinkPreviewProvider._internal();

  @override
  Future<Map<String, dynamic>> getMetaData(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url];
    }
    var result = await preview.getUrlMetaData(url: url);
    _cache[url] = result;
    return result;
  }
}
