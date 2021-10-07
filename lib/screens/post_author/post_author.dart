import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/body.dart';

class PostAuthorScreen extends StatefulWidget {
  static const routeName = '/post_author';

  final Map<String, dynamic>? args;

  const PostAuthorScreen({Key? key, this.args}) : super(key: key);

  @override
  _PostAuthorScreenState createState() => _PostAuthorScreenState();
}

class _PostAuthorScreenState extends State<PostAuthorScreen> with SnackMixin, LoadingMixin {
  bool _loading = true;
  PostAuthor? _postAuthor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Instance post receive
    if (widget.args!['author'] != null && widget.args!['author'].runtimeType == PostAuthor) {
      _postAuthor = widget.args!['author'];
      setState(() {
        _loading = false;
      });
    } else {
      int id = ConvertData.stringToInt(widget.args?['id']);
      getPostAuthor(id);
    }
  }

  Future<void> getPostAuthor(int id) async {
    try {
      if (id != 0) {
        _postAuthor = await Provider.of<RequestHelper>(context).getPostAuthor(id: id);
      }
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(
              child: buildLoading(context, isLoading: _loading),
            )
          : Body(author: _postAuthor),
    );
  }
}
