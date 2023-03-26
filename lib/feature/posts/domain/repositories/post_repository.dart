abstract class PostRepository {
  Future fetchPosts(int fetchLimit, int offset);
  Future createPost(Map args);
  Future fetchPost(String id);
  Future deletePost(String id);
}