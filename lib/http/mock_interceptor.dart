import 'package:dio/dio.dart';
import 'package:movie_app/common/public.dart';
import 'package:movie_app/http/api/apis.dart';

/// Mock数据拦截器
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String path = options.path.toString();
    
    // 拦截Token请求
    if (path.contains("App.JYApp_Main.GetToken")) {
      return handler.resolve(_mockTokenResponse());
    }
    
    // 拦截广告请求
    if (path.contains("App.JYApp_Main.GetLaunchAds")) {
      return handler.resolve(_mockLaunchAdsResponse());
    }
    
    // 其他请求正常处理
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
} 