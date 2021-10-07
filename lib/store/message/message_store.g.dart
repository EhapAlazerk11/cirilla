// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessageStore on _MessageStore, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_MessageStore.canLoadMore')).value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_MessageStore.loading')).value;
  Computed<ObservableList<MessageData>>? _$messagesComputed;

  @override
  ObservableList<MessageData> get messages => (_$messagesComputed ??=
          Computed<ObservableList<MessageData>>(() => super.messages, name: '_MessageStore.messages'))
      .value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count, name: '_MessageStore.count')).value;
  Computed<int>? _$countUnReadComputed;

  @override
  int get countUnRead =>
      (_$countUnReadComputed ??= Computed<int>(() => super.countUnRead, name: '_MessageStore.countUnRead')).value;

  final _$_loadingAtom = Atom(name: '_MessageStore._loading');

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  final _$_messagesAtom = Atom(name: '_MessageStore._messages');

  @override
  ObservableList<MessageData> get _messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  set _messages(ObservableList<MessageData> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  final _$_canLoadMoreAtom = Atom(name: '_MessageStore._canLoadMore');

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  final _$setMessageKeyAsyncAction = AsyncAction('_MessageStore.setMessageKey');

  @override
  Future<void> setMessageKey(String value) {
    return _$setMessageKeyAsyncAction.run(() => super.setMessageKey(value));
  }

  final _$getMessagesAsyncAction = AsyncAction('_MessageStore.getMessages');

  @override
  Future<void> getMessages() {
    return _$getMessagesAsyncAction.run(() => super.getMessages());
  }

  final _$refreshAsyncAction = AsyncAction('_MessageStore.refresh');

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  final _$removeMessageByIdAsyncAction = AsyncAction('_MessageStore.removeMessageById');

  @override
  Future<void> removeMessageById({String? messageId}) {
    return _$removeMessageByIdAsyncAction.run(() => super.removeMessageById(messageId: messageId));
  }

  final _$removeMessageByIndexAsyncAction = AsyncAction('_MessageStore.removeMessageByIndex');

  @override
  Future<void> removeMessageByIndex({int? index}) {
    return _$removeMessageByIndexAsyncAction.run(() => super.removeMessageByIndex(index: index));
  }

  final _$insertMessageAsyncAction = AsyncAction('_MessageStore.insertMessage');

  @override
  Future<void> insertMessage({int? index, MessageData? element}) {
    return _$insertMessageAsyncAction.run(() => super.insertMessage(index: index, element: element));
  }

  final _$readMessageAsyncAction = AsyncAction('_MessageStore.readMessage');

  @override
  Future<void> readMessage({String? messageId}) {
    return _$readMessageAsyncAction.run(() => super.readMessage(messageId: messageId));
  }

  final _$removeMessagesAsyncAction = AsyncAction('_MessageStore.removeMessages');

  @override
  Future<void> removeMessages() {
    return _$removeMessagesAsyncAction.run(() => super.removeMessages());
  }

  @override
  String toString() {
    return '''
canLoadMore: ${canLoadMore},
loading: ${loading},
messages: ${messages},
count: ${count},
countUnRead: ${countUnRead}
    ''';
  }
}
