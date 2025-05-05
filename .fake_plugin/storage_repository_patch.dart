import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:movies_data/movies_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storage_api/storage_api.dart';

// 创建FakeFavoritesStorageApi类
class FakeFavoritesStorageApi implements FavoritesStorageApi {
  final _moviesStreamController = BehaviorSubject<List<MovieItemEntity>>.seeded(const []);
  
  @override
  Stream<List<MovieItemEntity>> getMovies() => _moviesStreamController.asBroadcastStream();
  
  @override
  Future<void> saveMovie(MovieItemEntity movie) async {
    final values = [..._moviesStreamController.value];
    values.add(movie);
    _moviesStreamController.add(values);
  }
  
  @override
  Future<void> deleteMovie(String id) async {
    final values = [..._moviesStreamController.value];
    final index = values.indexWhere((movie) => movie.id == id);
    if (index != -1) {
      values.removeAt(index);
      _moviesStreamController.add(values);
    } else {
      throw MovieNotFoundException();
    }
  }
  
  @override
  Future<void> clearAll() async {
    _moviesStreamController.add([]);
  }
  
  @override
  Future<bool> checkWhetherIsMarkedOrNot(String id) async {
    return _moviesStreamController.value.any((movie) => movie.id == id);
  }
  
  @override
  void close() {
    _moviesStreamController.close();
  }
}

// 创建FakeGenresStorageApi类
class FakeGenresStorageApi implements GenresStorageApi {
  final _genresStreamController = BehaviorSubject<Set<GenreEntity>>.seeded({});
  
  @override
  Stream<Set<GenreEntity>> getGenres() => _genresStreamController;
  
  @override
  Future<void> saveListOfGenres(Set<GenreEntity> genres) async {
    final values = _genresStreamController.value;
    _genresStreamController.add({...values, ...genres});
  }
  
  @override
  Future<void> changeFlag(GenreEntity genre) async {
    final newGenre = genre.changeFlag();
    final values = _genresStreamController.value.toList();
    final index = values.indexWhere((e) => e.id == genre.id);
    if (index >= 0) {
      values[index] = newGenre;
      _genresStreamController.add({...values});
    } else {
      throw GenreNotFoundException();
    }
  }
  
  @override
  Future<void> deleteGenre(String id) async {
    final values = {..._genresStreamController.value};
    try {
      final genre = values.lastWhere((e) => e.id == id);
      values.remove(genre);
      _genresStreamController.add(values);
    } catch (e) {
      throw GenreNotFoundException();
    }
  }
  
  @override
  Future<void> clearGenre() async {
    _genresStreamController.add({});
  }
  
  @override
  void close() {
    _genresStreamController.close();
  }
}

// 修改后的StorageRepository类，处理BoxCollection为null的情况
class SafeStorageRepository extends StorageRepository {
  SafeStorageRepository(BoxCollection? boxCollection)
      : super(boxCollection ?? _createFakeBoxCollection());
  
  static BoxCollection _createFakeBoxCollection() {
    debugPrint('创建FakeBoxCollection作为StorageRepository的备选实现');
    return FakeBoxCollection();
  }
}

// 简单的BoxCollection实现
class FakeBoxCollection implements BoxCollection {
  final Set<String> _boxNames = {};
  final String _name = "fake_collection";
  
  @override
  Future<void> close() async {}
  
  @override
  Future<CollectionBox<V>> openBox<V>(String name, {
    dynamic boxCreator,
    bool preload = false,
  }) async {
    _boxNames.add(name);
    return FakeCollectionBox<V>(name, this);
  }
  
  @override
  Future<void> deleteBox(String name) async {
    _boxNames.remove(name);
  }
  
  @override
  Future<List<String>> getBoxNames() async {
    return _boxNames.toList();
  }
  
  @override
  Future<void> deleteFromDisk() async {}
  
  @override
  Future<void> transaction(Future<void> Function() action, {
    List<String>? boxNames,
    bool readOnly = false,
  }) async {
    await action();
  }
  
  @override
  Set<String> get boxNames => _boxNames;
  
  @override
  String get name => _name;
}

// 简单的CollectionBox实现
class FakeCollectionBox<T> implements CollectionBox<T> {
  final Map<String, T> _data = {};
  final String _name;
  final BoxCollection _boxCollection;
  
  FakeCollectionBox(this._name, this._boxCollection);
  
  @override
  Future<void> put(String key, T value, [Object? transactionId]) async {
    _data[key] = value;
  }
  
  @override
  Future<T?> get(String key) async {
    return _data[key];
  }
  
  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
  
  @override
  Future<void> clear() async {
    _data.clear();
  }
  
  @override
  Future<List<String>> getAllKeys() async {
    return _data.keys.toList();
  }
  
  @override
  String get name => _name;
  
  @override
  Future<List<T?>> getAll(List<String> keys) async {
    return keys.map((key) => _data[key]).toList();
  }
  
  @override
  Future<void> putAll(Map<String, T> entries) async {
    _data.addAll(entries);
  }
  
  @override
  Future<int> length() async {
    return _data.length;
  }
  
  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in keys) {
      _data.remove(key);
    }
  }
  
  @override
  Future<void> flush() async {}
  
  @override
  Future<Map<String, T>> getAllValues() async {
    return Map<String, T>.from(_data);
  }
  
  @override
  BoxCollection get boxCollection => _boxCollection;
} 