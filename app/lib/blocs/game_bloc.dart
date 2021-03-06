import 'package:bloc/bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';

class GameBloc extends Bloc<GameEvent, Challenge> {
  final Challenge initialState;

  GameBloc(this.initialState);

  @override
  Stream<Challenge> mapEventToState(GameEvent event) async* {
    if (event is GameButton) {
      if (!currentState.started) {
        // Convert the absolute duration to a relative one
        DateTime newEndTime =
            DateTime.now().add(currentState.end.difference(DateTime(0, 0, 0)));
        Challenge newChallenge = currentState.copyWithNewEndTime(newEndTime);
        yield await event.challengeProvider.addChallenge(newChallenge);
      }
    }

    if (event is FriendButton) {
      if (currentState.participants.contains(event.friend)) {
        yield currentState.copyWithoutParticipant(event.friend);
      } else {
        yield currentState.copyWithParticipant(event.friend);
      }
    }

    if (event is UploadPictureButton) {
      yield await event.uploader.uploadPicture(event.file.path, currentState);
    }

    if (event is FinishChallengeButton) {
      Challenge newChallenge =
          currentState.copyWithParticipantFinished(event.user.id);
      await event.challengeProvider.updateChallenge(newChallenge);
      yield newChallenge;
    }

    if (event is CompleteChallenge) {
      Challenge newChallenge = currentState.copyAsComplete();
      await event.challengeProvider.updateChallenge(newChallenge);
      yield newChallenge;
    }

    // Duration is stored in the challenge.end field
    if (event is SetDuration) {
      // Should not be able to set a match duration after it has started
      assert(!currentState.started);
      yield currentState.copyWithNewEndTime(event.duration);
    }
  }
}
