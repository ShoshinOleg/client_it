part of 'post_cubit.dart';

@freezed
class PostState with _$PostState {
  const factory PostState({
    @JsonKey(includeToJson: false, includeFromJson: false)
    AsyncSnapshot? asyncSnapshot,
    @Default([]) List<PostEntity> postList,
    @Default(10) int fetchLimit,
    @Default(0) int offset,
  }) = _PostState;
}
