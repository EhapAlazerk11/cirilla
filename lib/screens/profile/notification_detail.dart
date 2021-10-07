import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/store/message/message_store.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/date_format.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class NotificationDetail extends StatefulWidget {
  static const routeName = '/notification_detail';

  final MessageData? args;

  const NotificationDetail({Key? key, this.args}) : super(key: key);

  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> with AppBarMixin, Utility {
  late MessageStore _messageStore;

  @override
  void didChangeDependencies() {
    _messageStore = Provider.of<MessageStore>(context);
    _messageStore.readMessage(messageId: widget.args?.messageId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String title = get(widget.args?.notification, ['title'], '');
    String body = get(widget.args?.notification, ['body'], '');
    String? sentTime = widget.args?.sentTime;

    return Theme(
      data: theme.copyWith(canvasColor: Colors.transparent),
      child: Scaffold(
        appBar: baseStyleAppBar(
          context,
          title: AppLocalizations.of(context)!.translate('notifications_detail_title')!,
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => buildDialog(context),
              child: Text(AppLocalizations.of(context)!.translate('notifications_detail_delete')!),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24)),
            ),
          ),
        ),
        body: Column(
          children: [
            NotificationItem(
              onTap: () {},
              title: Text(
                title,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              leading: Icon(FeatherIcons.messageCircle, color: Theme.of(context).primaryColor, size: 22),
              date: Text(sentTime != null ? formatDate(date: sentTime, dateFormat: 'MMMM d, y') : '',
                  style: Theme.of(context).textTheme.caption),
              time: Text(sentTime != null ? formatDate(date: sentTime, dateFormat: 'jm') : '',
                  style: Theme.of(context).textTheme.caption),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Color(0xFF647C9C)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> buildDialog(BuildContext context) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('notifications_detail_dialog_title')!),
        content: Text(AppLocalizations.of(context)!.translate('notifications_detail_dialog_description')!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_detail_dialog_cancel')!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_detail_dialog_ok')!),
          ),
        ],
      ),
    );
    if (result == "OK") {
      _messageStore.removeMessageById(messageId: widget.args?.messageId);
      Navigator.of(context).pop();
    }
  }
}
