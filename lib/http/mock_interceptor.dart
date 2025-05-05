import 'package:dio/dio.dart';
import 'package:movie_app/common/public.dart';
import 'package:movie_app/http/api/apis.dart';
import 'dart:math';

/// Mock数据拦截器
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String path = options.path.toString();
    
    print("拦截请求: $path");
    
    // 拦截Token请求
    if (path.contains("App.JYApp_Main.GetToken")) {
      return handler.resolve(_mockTokenResponse());
    }
    
    // 拦截广告请求
    if (path.contains("App.JYApp_Main.GetLaunchAds")) {
      return handler.resolve(_mockLaunchAdsResponse());
    }
    
    // 拦截推荐列表请求
    if (path.contains("recommand.php")) {
      return handler.resolve(_mockRecommendListResponse());
    }
    
    // 拦截视频数据请求
    if (path.contains("video") || path.contains("detail")) {
      return handler.resolve(_mockVideoDetailResponse(options));
    }
    
    // 拦截首页列表请求
    if (path.contains("list") || path.contains("home")) {
      return handler.resolve(_mockHomeListResponse());
    }
    
    // 拦截搜索请求
    if (path.contains("search")) {
      return handler.resolve(_mockSearchResponse());
    }
    
    // 拦截用户信息请求
    if (path.contains("user") || path.contains("profile")) {
      return handler.resolve(_mockUserProfileResponse());
    }
    
    // 其他请求正常处理
    print("未处理的请求: $path");
    return super.onRequest(options, handler);
  }
  
  // Mock Token响应
  Response _mockTokenResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "token": "mock_token_12345678"
      }
    };
    
    return Response(
      requestOptions: RequestOptions(path: Apis.token),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 广告响应
  Response _mockLaunchAdsResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "adimageurl": "https://picsum.photos/800/600",
        "adimageclickurl": "https://example.com",
        "adtimes": 5,
        "show": 1
      }
    };
    
    return Response(
      requestOptions: RequestOptions(path: Apis.getLaunchAds),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 推荐列表响应
  Response _mockRecommendListResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": _generateMockVideos(20)
    };
    
    return Response(
      requestOptions: RequestOptions(path: Apis.getRecommandList),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 视频详情响应
  Response _mockVideoDetailResponse(RequestOptions options) {
    // 从URL中获取视频ID
    String videoId = "video_" + Random().nextInt(1000).toString();
    if (options.queryParameters.containsKey("id")) {
      videoId = options.queryParameters["id"].toString();
    }
    
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "id": videoId,
        "title": "示例视频 $videoId",
        "description": "这是一个示例视频描述，用于测试应用界面显示。",
        "cover_url": "https://picsum.photos/800/450?random=${Random().nextInt(100)}",
        "video_url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "duration": "12:34",
        "views": Random().nextInt(10000),
        "likes": Random().nextInt(5000),
        "release_date": "2023-${Random().nextInt(12) + 1}-${Random().nextInt(28) + 1}",
        "tags": ["示例", "测试", "视频"],
        "related_videos": _generateMockVideos(5)
      }
    };
    
    return Response(
      requestOptions: options,
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 首页列表响应
  Response _mockHomeListResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "banner": [
          {
            "id": "banner_1",
            "title": "热门影片1",
            "image_url": "https://picsum.photos/800/300?random=1",
            "link": "video_101"
          },
          {
            "id": "banner_2",
            "title": "热门影片2",
            "image_url": "https://picsum.photos/800/300?random=2",
            "link": "video_102"
          },
          {
            "id": "banner_3",
            "title": "热门影片3",
            "image_url": "https://picsum.photos/800/300?random=3",
            "link": "video_103"
          }
        ],
        "categories": [
          {
            "id": "cat_1",
            "name": "最新上架",
            "videos": _generateMockVideos(8)
          },
          {
            "id": "cat_2",
            "name": "热门推荐",
            "videos": _generateMockVideos(8)
          },
          {
            "id": "cat_3",
            "name": "经典回顾",
            "videos": _generateMockVideos(8)
          }
        ]
      }
    };
    
    return Response(
      requestOptions: RequestOptions(path: "home/list"),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 搜索响应
  Response _mockSearchResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "results": _generateMockVideos(10),
        "total": 100,
        "page": 1,
        "page_size": 10
      }
    };
    
    return Response(
      requestOptions: RequestOptions(path: "search"),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // Mock 用户信息响应
  Response _mockUserProfileResponse() {
    Map<String, dynamic> responseData = {
      "code": 200,
      "message": "Success",
      "data": {
        "user_id": "user_12345",
        "username": "测试用户",
        "avatar": "https://picsum.photos/200/200?random=1",
        "email": "test@example.com",
        "vip_level": 1,
        "vip_expire": "2023-12-31",
        "favorites": _generateMockVideos(5),
        "history": _generateMockVideos(8)
      }
    };
    
    return Response(
      requestOptions: RequestOptions(path: "user/profile"),
      data: responseData,
      statusCode: 200,
    );
  }
  
  // 生成模拟视频数据
  List<Map<String, dynamic>> _generateMockVideos(int count) {
    List<Map<String, dynamic>> videos = [];
    
    for (int i = 0; i < count; i++) {
      int id = Random().nextInt(1000) + 1;
      videos.add({
        "id": "video_$id",
        "title": "示例视频 #$id",
        "cover_url": "https://picsum.photos/400/225?random=$id",
        "video_url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "duration": "${Random().nextInt(10)}:${Random().nextInt(60).toString().padLeft(2, '0')}",
        "views": Random().nextInt(10000),
        "likes": Random().nextInt(5000),
        "category": "示例分类${Random().nextInt(5) + 1}"
      });
    }
    
    return videos;
  }
} 