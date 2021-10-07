import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/screens/profile/notification_detail.dart';
import 'package:cirilla/store/message/message_store.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/date_format.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:ui/ui.dart';

class NotificationList extends StatefulWidget {
  static const routeName = '/notification_list';

  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> with AppBarMixin, Utility {
  late MessageStore _messageStore;

  @override
  void didChangeDependencies() async {
    _messageStore = Provider.of<MessageStore>(context)..getMessages();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: AppLocalizations.of(context)!.translate('notifications_list_title')!,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 10),
            child: IconButton(
              icon: Icon(FeatherIcons.trash2),
              onPressed: () => buildDialog(context),
              iconSize: 20,
            ),
          )
        ],
      ),
      body: Observer(
        builder: (_) {
          List<MessageData> data = _messageStore.messages;
          return _messageStore.count == 0
              ? _buildNotificationEmpty()
              : ListView(
                  children: List.generate(_messageStore.count, (index) => buildItem(index, data[index])),
                );
        },
      ),
    );
  }

  Widget buildItem(int index, MessageData message) {
    String title = get(message.notification, ['title'], '');
    String? sentTime = message.sentTime;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(message.messageId!),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        _messageStore.removeMessageByIndex(index: index);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('notifications_list_delete')!),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.translate('undo')!,
            onPressed: () => _messageStore.insertMessage(index: index, element: message),
          ),
        ));
      },
      // Show a red background as the item is swiped away.
      background: Container(color: Colors.red),
      child: Column(
        children: [
          NotificationItem(
            onTap: () => Navigator.of(context).pushNamed(NotificationDetail.routeName, arguments: message),
            title: Text(
              title,
              style: message.read!
                  ? textTheme.subtitle2!.copyWith(color: textTheme.bodyText1!.color)
                  : textTheme.subtitle2,
            ),
            leading: Icon(FeatherIcons.messageCircle, color: theme.primaryColor, size: 22),
            trailing: message.read! ? null : Icon(Icons.circle, size: 8, color: Color(0xFF2BBD69)),
            date: Text(sentTime != null ? formatDate(date: sentTime, dateFormat: 'MMMM d, y') : '',
                style: textTheme.caption),
            time: Text(sentTime != null ? formatDate(date: sentTime, dateFormat: 'jm') : '', style: textTheme.caption),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 0),
          )
        ],
      ),
    );
  }

  Future<void> buildDialog(BuildContext context) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_title')!),
        content: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_description')!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_cancel')!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_ok')!),
          ),
        ],
      ),
    );
    if (result == "OK") {
      _messageStore.removeMessages();
    }
  }

  Widget _buildNotificationEmpty() {
    return NotificationScreen(
      title: Text(AppLocalizations.of(context)!.translate('notifications_no')!,
          style: Theme.of(context).textTheme.headline6),
      content: Text(AppLocalizations.of(context)!.translate('notifications_you_currently')!,
          style: Theme.of(context).textTheme.bodyText2),
      iconData: FeatherIcons.bell,
      textButton: Text(AppLocalizations.of(context)!.translate('notifications_back')!),
      styleBtn: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 61)),
      onPressed: () => Navigator.pop(context),
    );
  }
}
