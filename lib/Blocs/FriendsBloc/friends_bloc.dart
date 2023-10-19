import 'friends_event.dart';
import 'friends_state.dart';
import '../../Models/user_model.dart';
import 'package:bloc/bloc.dart';
import '../../Repository/friends_repository.dart';
import '../../Utils/result_classes.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepository _friendsRepository;

  FriendsBloc({required FriendsRepository friendsRepository})
      : _friendsRepository = friendsRepository,
        super(EmptyFriendsState()) {
    on<GetFriends>(
      (event, emit) async {
        await _friendsRepository
            .getFriendsData(userId: event.userId)
            .then((value) {
          if (value is SuccessState<List<UserModel>>) {
            emit(SuccessFriendsState(value.data));
          } else if (value is ErrorState<List<UserModel>>) {
            emit(ErrorFriendsState(value.error));
          }
        });
      },
    );

    on<ManageFriendshipRequest>(
      (event, emit) async {
        await _friendsRepository
            .manageFriendship(
          operationType: event.operationType,
          userId: event.currentUserId,
          friendId: event.friendId,
        )
            .then((value) {
          emit(const LoadingManagingFriendshipState());
          if (value is SuccessState<bool>) {
            emit(const SuccessManagingFriendshipState());
          } else if (value is ErrorState<bool>) {
            emit(ErrorManagingFriendshipState(value.error));
          }
        });
      },
    );
  }
}
