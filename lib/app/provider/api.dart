import 'api_interface.dart';
import 'interceptors/log.dart';

class ProdApiProvider extends ApiProvider {
  ProdApiProvider() : super() {
    dio.interceptors.add(LogInterceptor());
  }
}
