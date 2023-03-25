import 'package:client_it/feature/posts/domain/entity/post/post_entity.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  const PostItem({Key? key, required this.postEntity}) : super(key: key);

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Text(postEntity.name),
          Text(postEntity.preContent ?? ""),
          Text("Автор: ${postEntity.author?.id ?? ""}"),
        ],
      ),
    );
  }
}
