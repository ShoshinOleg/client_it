abstract class PostRepository {
  Future fetchPosts();
  Future createPost(Map args);
}