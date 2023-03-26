import 'package:client_it/app/domain/app_api.dart';
import 'package:client_it/feature/posts/domain/entity/post/post_entity.dart';
import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostRepository)
@prod
class NetPostRepository implements PostRepository {
  final AppApi api;

  NetPostRepository(this.api);

  @override
  Future<Iterable> fetchPosts(int fetchLimit, int offset) async {
    try {
      final response = await api.fetchPosts(fetchLimit, offset);
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

  @override
  Future fetchPost(String id) async {
    final response = await api.fetchPost(id);
    return PostEntity.fromJson(response.data["data"]);
  }

  @override
  Future deletePost(String id) async {
    await api.deletePost(id);
  }
}