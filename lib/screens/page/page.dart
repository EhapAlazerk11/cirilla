import 'dart:async';
import 'dart:io';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/page/page_data.dart';
import 'package:cirilla/screens/post/blocks/blocks.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageScreen extends StatefulWidget {
  static const routeName = '/page';

  final Map? args;

  const PageScreen({Key? key, this.args}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> with LoadingMixin, SnackMixin, AppBarMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _loading = true;

  PageData? _pageData;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Instance post receive
    if (widget.args!['post'] != null && widget.args!['post'].runtimeType == PageData) {
      _pageData = widget.args!['post'];
      setState(() {
        _loading = false;
      });
    } else {
      getPost(ConvertData.stringToInt(widget.args!['id']));
    }
  }

  Future<void> getPost(int id) async {
    try {
      _pageData = await Provider.of<RequestHelper>(context).getPageDetail(idPage: id);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pageData == null) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: widget.args!['name'] ?? ''),
        body: Container(),
      );
    }
    return Scaffold(
      appBar: baseStyleAppBar(context, title: widget.args!['name'] ?? ''),
      body: widget.args != null && widget.args!['url'] == null
          ? CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, top: 32, bottom: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == _pageData!.blocks!.length - 1) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PostBlock(block: _pageData!.blocks![index]),
                            ],
                          );
                        }
                        return PostBlock(block: _pageData!.blocks![index]);
                      },
                      childCount: _pageData!.blocks!.length,
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                WebView(
                  initialUrl: widget.args!['url'],
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                  },
                  navigationDelegate: (NavigationRequest request) {
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _loading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                ),
                if (_loading) buildLoading(context, isLoading: _loading),
              ],
            ),
    );
  }
}
