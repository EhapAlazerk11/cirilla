import 'dart:convert';

import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'message_store.g.dart';

class MessageStore = _MessageStore with _$MessageStore;

abstract class _MessageStore with Store {
  final PersistHelper _persistHelper;
  @observable
  bool _loading = false;

  @observable
  ObservableList<MessageData> _messages = ObservableList<MessageData>.of([]);

  @observable
  bool _canLoadMore = true;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => _loading;

  @computed
  ObservableList<MessageData> get messages => _messages;

  @computed
  int get count => _messages.length;

  @computed
  int get countUnRead => _messages.where((element) => !element.read!).length;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<void> setMessageKey(String value) async {
    // if (value == null) return;
    // _cartKey = value;
    // return await _persistHelper.saveMessageKey(value);
  }

  @action
  Future<void> getMessages() async {
    _loading = true;
    List<String>? messages = await _persistHelper.getMessages();
    if (messages != null) {
      _messages =
          ObservableList<MessageData>.of(messages.map((message) => MessageData.fromJson(jsonDecode(message))).toList());
    } else {
      _messages.clear();
    }
    _loading = false;
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    return getMessages();
  }

  Future<void> saveMessages({required List<MessageData> msg}) async {
    await _persistHelper.saveMessages(msg.map((e) => jsonEncode(e.toJson())).toList());
  }

  @action
  Future<void> removeMessageById({String? messageId}) async {
    if (messageId != null) {
      List<MessageData> msg = _messages.where((element) => element.messageId != messageId).toList();
      await saveMessages(msg: msg);
      _messages = ObservableList<MessageData>.of(msg);
    }
  }

  @action
  Future<void> removeMessageByIndex({int? index}) async {
    if (index != null && index >= 0) {
      List<MessageData> msg = List<MessageData>.of(_messages);
      msg.removeAt(index);
      await saveMessages(msg: msg);
      _messages = ObservableList<MessageData>.of(msg);
    }
  }

  @action
  Future<void> insertMessage({int? index, MessageData? element}) async {
    if (index != null && index >= 0 && element != null) {
      List<MessageData> msg = List<MessageData>.of(_messages);
      msg.insert(index, element);
      await saveMessages(msg: msg);
      _messages = ObservableList<MessageData>.of(msg);
    }
  }

  @action
  Future<void> readMessage({String? messageId}) async {
    if (messageId != null) {
      List<MessageData> msg = _messages.map((e) {
        if (messageId == e.messageId) {
          return MessageData.readMessage(true, e);
        }
        return e;
      }).toList();
      await saveMessages(msg: msg);
      _messages = ObservableList<MessageData>.of(msg);
    }
  }

  @action
  Future<void> removeMessages() async {
    await _persistHelper.removeMessages();
    await getMessages();
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  _MessageStore(this._persistHelper) {
    _reaction();
  }

  Future init() async {
    await restore();
  }

  Future<void> restore() async {}

  // Disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
