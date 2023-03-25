import 'package:client_it/app/domain/app_api.dart';
import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostRepository)
@prod
class NetPostRepository implements PostRepository {
  final AppApi api;

  NetPostRepository(this.api);

  @override
  Future<Iterable> fetchPosts() async {
    try {
      final response = await api.fetchPosts();
      return response.data;
    } catch(error) {
      rethrow;
    }
  }

  @override
  Future<String> createPost(Map args) async {
    try {
      final response = await api.createPost(args);
      return response.data["message"];
    } catch(error) {
      rethrow;
    }
  }
}