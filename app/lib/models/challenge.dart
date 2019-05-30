import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String owner;
  final List<String> participants;
  final String ingredient;
  final bool complete;
  final Timestamp endTime;

  Challenge(this.id, this.owner, this.participants, this.ingredient,
      this.complete, this.endTime);

  Challenge addParticipant(String participant) {
    return Challenge(id, owner, participants..add(participant), ingredient,
        complete, endTime);
  }
}
