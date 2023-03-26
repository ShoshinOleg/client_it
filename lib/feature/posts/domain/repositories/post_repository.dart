abstract class PostRepository {
  Future fetchPosts();
  Future createPost(Map args);
  Future fetchPost(String id);
  Future deletePost(String id);
}