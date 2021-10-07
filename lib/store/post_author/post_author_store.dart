import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:mobx/mobx.dart';

part 'post_author_store.g.dart';

class PostAuthorStore = _PostAuthorStore with _$PostAuthorStore;

abstract class _PostAuthorStore with Store {
  final String? key;
  // Request helper instance
  RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _PostAuthorStore(
    this._requestHelper, {
    int? perPage,
    this.key,
    String? lang,
  }) {
    if (perPage != null) _perPage = perPage;
    if (lang != null) _lang = lang;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<PostAuthor>> emptyPostAuthorResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<PostAuthor>?> fetchPostAuthorsFuture = emptyPostAuthorResponse;

  @observable
  ObservableList<PostAuthor> _postAuthors = ObservableList<PostAuthor>.of([]);

  @observable
  bool success = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 1;

  @observable
  bool _loading = true;

  @observable
  bool _canLoadMore = true;

  @observable
  String? _lang;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchPostAuthorsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<PostAuthor> get postAuthors => _postAuthors;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getPostAuthors() async {
    final future = _requestHelper.getPostAuthors(queryParameters: {
      "per_page": _perPage,
      'page': _nextPage,
      "lang": _lang ?? '',
    });
    fetchPostAuthorsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _postAuthors = ObservableList<PostAuthor>.of(data!);
      } else {
        // Add posts when load more page
        _postAuthors.addAll(ObservableList<PostAuthor>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
    }).catchError((error) {
      print(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getPostAuthors();
  }

  // disposers:-----------------------------------------------------------------
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
