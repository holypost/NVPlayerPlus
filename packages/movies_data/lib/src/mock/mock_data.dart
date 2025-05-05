import 'package:movies_data/src/models/models.dart';

/// 提供mock数据，解决API超时问题
class MockDataProvider {
  /// 获取模拟的电影列表数据
  static MoviesList getMockMoviesList(int page) {
    final movies = List.generate(
      20,
      (index) => MovieItem(
        id: (index + 1).toString(),
        title: '模拟电影 ${index + 1}',
        rate: (7.0 + (index % 3) * 0.5).toString(),
        posterPath: 'https://via.placeholder.com/500x750?text=电影${index + 1}',
        backdropPath: 'https://via.placeholder.com/1280x720?text=电影预览${index + 1}',
        uploadUserUri: 'https://via.placeholder.com/150?text=用户',
        uploadUserNickname: '用户${index % 5 + 1}',
      ),
    );
    
    return MoviesList(movies: movies, page: page);
  }
  
  /// 获取模拟的电影详情数据
  static MovieDetail getMockMovieDetail(String movieId) {
    return MovieDetail(
      id: movieId,
      title: '模拟电影详情 $movieId',
      poserPath: 'https://via.placeholder.com/500x750?text=电影$movieId',
      backdropPath: 'https://via.placeholder.com/1280x720?text=电影预览$movieId',
      duration: '120',
      rating: '8.5',
      releaseData: '2024-05-01',
      genres: ['动作', '冒险', '科幻'],
      overview: '这是一部模拟的电影，用于测试应用程序在API超时情况下的表现。这部电影讲述了一个引人入胜的故事，包含精彩的动作场景和感人的情节。',
      language: 'zh',
    );
  }
  
  /// 获取模拟的分类数据
  static List<GenreItem> getMockGenres() {
    return [
      GenreItem(id: '1', name: '动作'),
      GenreItem(id: '2', name: '冒险'),
      GenreItem(id: '3', name: '喜剧'),
      GenreItem(id: '4', name: '科幻'),
      GenreItem(id: '5', name: '恐怖'),
      GenreItem(id: '6', name: '爱情'),
      GenreItem(id: '7', name: '动画'),
      GenreItem(id: '8', name: '纪录片'),
    ];
  }
} 