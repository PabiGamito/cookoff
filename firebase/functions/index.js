// Run 'firebase deploy --only functions' to deploy updated cloud function

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.offerTrigger = functions.firestore
  .document("challenges/{challengeId}")
  .onCreate((snapshot, context) => {
    const challenge = snapshot.data();

    return challengeCreationNotify(challenge);
  });

/**
 * Notify all challenge participants of challenge creation.
 * @param {documentReference} challenge
 */
async function challengeCreationNotify(challenge) {
  const db = admin.firestore();
  const participants = challenge.participants;
  const ownerId = challenge.owner;

  if (participants == undefined) {
    console.error(
      "Challenge has no participants field. Challenge :: ",
      challenge
    );
  }

  if (ownerId == undefined) {
    console.error("Challenge has no owner field. Challenge :: ", challenge);
  }

  const deviceTokens = [];

  for (const userId of participants) {
    console.log("User ID", userId);

    if (userId == ownerId) {
      continue;
    }

    const user = await db.doc("users/" + userId).get();

    if (user.data().deviceTokens == undefined) {
      console.error("User has no deviceTokens field. User :: ", user);
      continue;
    }

    for (const token of user.data().deviceTokens) {
      deviceTokens.push(token);
    }
  }

  const owner = await db.doc("users/" + ownerId).get();

  const ownerName = owner.data().name;

  const payload = {
    notification: {
      title: "Yo bru! You been challenged BRU!",
      body:
        ownerName +
        " has challenged you to a " +
        challenge.ingredient +
        " cookoff!",
      sound: "default"
    }
  };

  return admin
    .messaging()
    .sendToDevice(deviceTokens, payload)
    .then(response => {
      console.log("Notified participants of challenge creation", response);
    })
    .catch(err => {
      console.error("Failed to notify participants of challenge creation", err);
    });
}
