import 'package:bloc/bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/firebase/picture_firebase_adapter.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:cookoff/widgets/injector_widget.dart';

class GameBloc extends Bloc<GameEvent, Challenge> {
  final Challenge initialState;

  GameBloc(this.initialState);

  @override
  Stream<Challenge> mapEventToState(GameEvent event) async* {
    if (event is GameButton) {
      if (!currentState.started) {
        yield await event.challengeProvider
            .addChallenge(currentState);
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
      Challenge newChallenge = currentState.copyWithParticipantFinished(event.user.id);
      await event.challengeProvider.updateChallenge(newChallenge);
      yield newChallenge;
    }

    if (event is CompleteChallenge) {
      Challenge newChallenge = currentState.copyAsComplete();
      await event.challengeProvider.updateChallenge(newChallenge);
      yield newChallenge;
    }

  }
}
