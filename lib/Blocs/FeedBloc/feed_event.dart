import 'package:equatable/equatable.dart';
import '../../Models/Comments/comment.dart';
import '../../Models/post_model.dart';
import '../../Utils/operation_type.dart';
import '../../Utils/reactions_type.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class GetPosts extends FeedEvent {
  final String userId;

  const GetPosts({
    required this.userId,
  });

  @override
  List<Object> get props => [
        userId,
      ];
}

class GetFriendsData extends FeedEvent {
  final List<String> usersIds;

  const GetFriendsData({
    required this.usersIds,
  });

  @override
  List<Object> get props => [
        usersIds,
      ];
}

//ManagePost include add,update,delete a post.
class ManagePost extends FeedEvent {
  final OperationType postOperationType;
  final PostModel? oldPostModel;
  final PostModel newPostModel;

  const ManagePost({
    required this.postOperationType,
    this.oldPostModel,
    required this.newPostModel,
  });

  @override
  List<Object> get props => [];
}

//ManageReaction include add,update,delete a reaction.
class ManageReactions extends FeedEvent {
  final ReactionsType reactionType;
  final PostModel postModel;

  const ManageReactions({
    required this.reactionType,
    required this.postModel,
  });

  @override
  List<Object> get props => [];
}

//ManageComment include add,update,delete a comment.
class ManageComments extends FeedEvent {
  final OperationType postOperationType;
  final PostModel postModel;
  final Comment? newComment;
  final Comment? oldComment;

  const ManageComments({
    required this.postOperationType,
    required this.postModel,
    this.newComment,
    this.oldComment,
  });

  @override
  List<Object> get props => [];
}
