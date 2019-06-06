import 'package:bloc/bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/firebase/picture_firebase_adapter.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/widgets/injector_widget.dart';

class GameBloc extends Bloc<GameEvent, Challenge> {
  final Challenge initialState;

  GameBloc(this.initialState);

  @override
  Stream<Challenge> mapEventToState(GameEvent event) async* {
    if (event is GameButton) {
      if (!currentState.started) {
        yield await InjectorWidget.of(event.context)
            .injector
            .challengeProvider
            .addChallenge(currentState);
      } else {
        // TODO: mark user as finished
        // Currently just sets entire challenge as complete
        assert(!currentState.complete);
        yield currentState.copyAsComplete();
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
      yield await PictureFirebaseAdapter()
          .uploadPicture(event.file.path, currentState);
    }
  }
}
