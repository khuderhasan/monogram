import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Blocs/FeedBloc/feed_bloc.dart';
import '../../../Blocs/FeedBloc/feed_event.dart';
import '../../../Blocs/FeedBloc/feed_state.dart';
import '../../../Constants/app_colors.dart';
import '../../../Constants/app_styles.dart';
import '../../../GetIt/main_app.dart';
import '../../../Models/Comments/comment.dart';
import '../../../Models/post_model.dart';
import '../../../SharedWidgets/app_snack_bar.dart';
import '../../../SharedWidgets/main_scaffold.dart';
import '../../../Utils/operation_type.dart';
import 'comment_card.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';

class CommentsPage extends StatefulWidget {
  final PostModel post;

  const CommentsPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  late final FeedBloc _feedBloc = BlocProvider.of<FeedBloc>(context);

  bool isLoading = false;

  Comment? newComment;
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _feedBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        setState(() {
          isLoading = false;
        });
        if (state is ManageCommentsSucceededState) {
          if (newComment == null) return;
          widget.post.comments.insert(0, newComment!);
          newComment = null;
        } else if (state is ManageCommentsFailedState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: state.error.message));
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: MainScaffold(
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.post.comments
                        .map((comment) => CommentCard(
                              comment: comment,
                              onDelete: () {
                                setState(() {
                                  isLoading = true;
                                });
                                _feedBloc.add(
                                  ManageComments(
                                      postModel: widget.post,
                                      postOperationType: OperationType.delete,
                                      oldComment: comment),
                                );
                              },
                              onUpdate: (newContent) {
                                setState(() {
                                  isLoading = true;
                                });
                                Comment newComment = Comment(
                                    profilePicture: comment.profilePicture,
                                    userId: comment.userId,
                                    content: newContent,
                                    userName: comment.userName);
                                _feedBloc.add(
                                  ManageComments(
                                      postModel: widget.post,
                                      postOperationType: OperationType.update,
                                      oldComment: comment,
                                      newComment: newComment),
                                );
                                // comment.content = newContent;
                                setState(() {});
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: S.of(context).writeAComment,
                            hintStyle: AppStyles.h3,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          newComment = Comment(
                              userName: locator<MainApp>().user!.name,
                              content: commentController.text,
                              userId: locator<MainApp>().user!.id,
                              profilePicture:
                                  locator<MainApp>().user!.profilePictureUrl ??
                                      '');
                          _feedBloc.add(
                            ManageComments(
                                postModel: widget.post,
                                postOperationType: OperationType.add,
                                newComment: newComment),
                          );
                          setState(() {
                            isLoading = true;
                          });
                          commentController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: AppColors.monogramGrey,
                        ))
                  ],
                ),
              ),
            ],
          ),
          appBarTitle: S.of(context).comments,
          appBarLeading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
          appBarLeadingWidth: 60,
        ),
      ),
    );
  }
}
