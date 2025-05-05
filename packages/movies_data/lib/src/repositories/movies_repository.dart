import 'package:movies_api/movies_api.dart';
import 'package:movies_data/movies_data.dart';
import 'package:movies_data/src/models/models.dart';
import 'package:movies_data/src/api/movie_api_impl.dart';
import 'package:movies_data/src/repositories/base_repository.dart';
import 'package:movies_api/src/models/navi/navilist.dart';
import 'package:movies_api/src/models/navi/navi_newest.dart';
import 'package:movies_data/src/mock/mock_data.dart';
import 'dart:async';

const topRated = 'top_rated';
const upcoming = 'upcoming';
const latest = 'latest';
const nowPlaying = 'now_playing';
const popular = 'popular';
const imageUrl = 'https://image.tmdb.org/t/p/w500';
const originalImageUrl = 'https://image.tmdb.org/t/p/original';

// 是否使用mock数据
const bool USE_MOCK_DATA = true;
// API超时时间设置（毫秒）
const int API_TIMEOUT = 5000; 

enum MovieType { TOP_RATED, UPCOMING, LATEST, NOW_PLAYING, POPULAR }

extension GetMovieType on MovieType {
  String get getType {
    switch (this) {
      case MovieType.TOP_RATED:
        return 'top_rated';
      case MovieType.UPCOMING:
        return 'upcoming';
      case MovieType.LATEST:
        return 'latest';
      case MovieType.NOW_PLAYING:
        return 'now_playing';
      case MovieType.POPULAR:
        return 'popular';
    }
  }

  String get getTypeText {
    switch (this) {
      case MovieType.TOP_RATED:
        return 'Top rated';
      case MovieType.UPCOMING:
        return 'Upcoming';
      case MovieType.LATEST:
        return 'Latest';
      case MovieType.NOW_PLAYING:
        return 'Now playing';
      case MovieType.POPULAR:
        return 'Popular';
    }
  }
}

/// 电影主要网络处理请求和解析中心
class MoviesRepository extends BaseRepository {
  final MovieApi movieApiService = MovieApiServiceImpl();

  ///根据navi id 获取总数据
  Future<ResponseState<MoviesList>> getNavilistsByNID({
    required int page,
    required MovieType type,
  }) =>
      launchWithCatchError(() async {
        // 如果使用mock数据，直接返回
        if (USE_MOCK_DATA) {
          return MockDataProvider.getMockMoviesList(page);
        }
        
        try {
          // 设置超时
          final result = await movieApiService.getMovieByType(
            type: type.getType,
            page: page,
          ).timeout(Duration(milliseconds: API_TIMEOUT));

          final movies = result.results!.map(
            (element) => MovieItem(
              id: element.id.toString(),
              title: element.title.toString(),
              rate: element.voteAverage.toString(),
              posterPath: imageUrl + element.posterPath.toString(),
              backdropPath: originalImageUrl + element.backdropPath.toString(),
            ),
          );

          return MoviesList(movies: movies.toList(), page: result.page);
        } on TimeoutException {
          // 超时时返回mock数据
          return MockDataProvider.getMockMoviesList(page);
        }
      });

  Future<ResponseState<MoviesList>> getMoviesByType({
    required int page,
    required MovieType type,
  }) =>
      launchWithCatchError(() async {
        // 如果使用mock数据，直接返回
        if (USE_MOCK_DATA) {
          return MockDataProvider.getMockMoviesList(page);
        }
        
        try {
          // 设置超时
          final result = await movieApiService.getMovieByType(
            type: type.getType,
            page: page,
          ).timeout(Duration(milliseconds: API_TIMEOUT));

          final movies = result.results!.map(
            (element) => MovieItem(
              id: element.id.toString(),
              title: element.title.toString(),
              rate: element.voteAverage.toString(),
              posterPath: imageUrl + element.posterPath.toString(),
              backdropPath: originalImageUrl + element.backdropPath.toString(),
              uploadUserUri: 'https://via.placeholder.com/150?text=用户',
              uploadUserNickname: '用户1',
            ),
          );

          return MoviesList(movies: movies.toList(), page: result.page);
        } on TimeoutException {
          // 超时时返回mock数据
          return MockDataProvider.getMockMoviesList(page);
        }
      });

  Future<ResponseState<MoviesList>> getMoviesByQuery({
    String? query,
    required int page,
  }) =>
      launchWithCatchError(() async {
        final result = await movieApiService.getMoviesByQuery(
          query: query,
          page: page,
        );

        final movies = result.results!.map(
          (element) => MovieItem(
            id: element.id.toString(),
            title: element.title.toString(),
            rate: element.voteAverage.toString(),
            posterPath: imageUrl + element.posterPath.toString(),
            backdropPath: originalImageUrl + element.backdropPath.toString(),
          ),
        );

        return MoviesList(movies: movies.toList(), page: result.page);
      });

  Future<ResponseState<MoviesList>> discoverMovies({
    required int page,
    String? genreId,
    String? language,
    String? year,
  }) =>
      launchWithCatchError(() async {
        final result = await movieApiService.discoverMovies(
          page: page,
          genreId: genreId,
          language: language,
          year: year,
        );

        final movies = result.results!.map(
          (element) => MovieItem(
            id: element.id.toString(),
            title: element.title.toString(),
            rate: element.voteAverage.toString(),
            posterPath: imageUrl + element.posterPath.toString(),
            backdropPath: originalImageUrl + element.backdropPath.toString(),
          ),
        );

        return MoviesList(movies: movies.toList(), page: result.page);
      });

  Future<ResponseState<MovieDetail>> getMovieDetailNew(String movieId) =>
      launchWithCatchError(() async {
        final movie = await movieApiService.getMovieDetailNew(movieId: movieId);
        return MovieDetail(
          id: movie.resKey ?? "",
          title: movie.videoTitle ?? "",
          poserPath: movie.videoCover2 ?? "",
          backdropPath: movie.videoPreview ?? "",
          duration: movie.durationStr ?? "",
          rating: "$movie.commentTimes ?? 0",
          releaseData: "$movie.createdTick",
          genres: [],
          overview: movie.profile ?? "",
          language: "",
        );
      });

  Future<ResponseState<MovieDetail>> getMovieDetail(String movieId) =>
      launchWithCatchError(() async {
        // 如果使用mock数据，直接返回
        if (USE_MOCK_DATA) {
          return MockDataProvider.getMockMovieDetail(movieId);
        }
        
        try {
          // 尝试调用API并设置超时
          final movie = await movieApiService.getMovieDetail(
            movieId: movieId
          ).timeout(Duration(milliseconds: API_TIMEOUT));
          
          return MovieDetail(
            id: movie.id.toString(),
            title: movie.originalTitle.toString(),
            poserPath: imageUrl + movie.posterPath.toString(),
            backdropPath: originalImageUrl + movie.backdropPath.toString(),
            duration: movie.runtime.toString(),
            rating: movie.voteAverage.toString(),
            releaseData: movie.releaseDate.toString(),
            genres: movie.genres!.map((e) => e.name.toString()).toList(),
            overview: movie.overview.toString(),
            language: movie.originalLanguage.toString(),
          );
        } on TimeoutException {
          // 超时时返回mock数据
          return MockDataProvider.getMockMovieDetail(movieId);
        }
      });

  /// get all genres
  Future<ResponseState<List<GenreItem>>> getGenres() =>
      launchWithCatchError(() async {
        // 如果使用mock数据，直接返回
        if (USE_MOCK_DATA) {
          return MockDataProvider.getMockGenres();
        }
        
        try {
          // 尝试调用API并设置超时
          final result = await movieApiService.getAllGenres()
              .timeout(Duration(milliseconds: API_TIMEOUT));

          return result.genres!
              .map((e) => GenreItem(id: e.id, name: e.name))
              .toList();
        } on TimeoutException {
          // 超时时返回mock数据
          return MockDataProvider.getMockGenres();
        }
      });

  ///  get all Categrys
  Future<ResponseState<List<Categroy_Home>>> getCategorys() =>
      launchWithCatchError(() async {
        final result = await movieApiService.getAllCategory();

        return result;
      });

  // getAllNaviList
  Future<ResponseState<List<dynamic>>> getAllNaviList(
          {required String naviId}) =>
      launchWithCatchError(() async {
        final result = await movieApiService.getAllNaviList(naviId: naviId);

        return result;
      });

  Future<ResponseState<MoviesList>> getSimilarMovies(
          {required String movieId, int? page}) =>
      launchWithCatchError(() async {
        final result = await movieApiService.getSimilarMovies(
          movieId: movieId,
          page: page,
        );

        final movies = result.results!.map(
          (element) => MovieItem(
            id: element.id.toString(),
            title: element.title.toString(),
            rate: element.voteAverage.toString(),
            posterPath: imageUrl + element.posterPath.toString(),
            backdropPath: originalImageUrl + element.backdropPath.toString(),
          ),
        );

        return MoviesList(movies: movies.toList(), page: result.page);
      });

  Future<ResponseState<List<CastItem>>> getCastsById(
          {required String movieId}) =>
      launchWithCatchError(() async {
        final result = await movieApiService.getCastByMovieId(movieId: movieId);
        final casts =
            result.cast?.where((element) => element.profilePath != null) ?? [];

        return casts
            .map((e) => CastItem(
                  gender: e.gender,
                  id: e.id,
                  originalName: e.originalName,
                  popularity: e.popularity,
                  profilePath: '$imageUrl${e.profilePath}',
                  castId: e.castId,
                  character: e.character,
                  creditId: e.creditId,
                  order: e.order,
                ))
            .toList();
      });

  Future<ResponseState<Videos>> getVideosByMovieId({required String movieId}) =>
      launchWithCatchError(() async {
        final videos = await movieApiService.getVideoDataById(movieId: movieId);
        return Videos(
          id: videos.id.toString(),
          videos: videos.results!
              .map((e) => VideoItem(
                    name: e.name.toString(),
                    id: e.id.toString(),
                    size: e.size.toString(),
                    key: e.key.toString(),
                  ))
              .toList(),
        );
      });

  //分页获取Tab 根据标签名称
  Future<ResponseState<MoviesList>> getMoviesByNewest({
    required int page,
    required String navireskey,
  }) =>
      launchWithCatchError(() async {
        // 如果使用mock数据，直接返回
        if (USE_MOCK_DATA) {
          return MockDataProvider.getMockMoviesList(page);
        }
        
        try {
          // 尝试调用API并设置超时
          final result = await movieApiService.getMoviesByNewest(
            page: page, 
            navireskey: navireskey
          ).timeout(Duration(milliseconds: API_TIMEOUT));

          // 根据实际API返回结构处理
          final movies = result.map((element) {
            final item = NaviNewestItem.fromJson(element);
            return MovieItem(
              id: item.resKey ?? "",
              title: item.videoTitle ?? "",
              rate: item.durationStr ?? "",
              posterPath: item.videoCover2 ?? "",
              backdropPath: item.videoPreview ?? "",
              uploadUserUri: item.uploadUserInfo?.avatarUri ?? 'https://via.placeholder.com/150?text=用户',
              uploadUserNickname: item.uploadUserInfo?.nickName ?? '用户',
            );
          }).toList();

          return MoviesList(movies: movies, page: page);
        } on TimeoutException {
          // 超时时返回mock数据
          return MockDataProvider.getMockMoviesList(page);
        }
      });

  // getAllNaviList
  Future<ResponseState<List<dynamic>>> getTabDataByCateResKey(
          {required String navireskey}) =>
      launchWithCatchError(() async {
        final result = await movieApiService.getTabDataByCateResKey(
            navireskey: navireskey);
        return result;
      });
}
