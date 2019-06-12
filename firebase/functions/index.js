// Run 'firebase deploy --only functions' to deploy updated cloud function

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.offerTrigger = functions.firestore
  .document("challenges/{challengeId}")
  .onCreate((snapshot, context) => {
    const challenge = snapshot.data();

    return admin
      .firestore()
      .collection("users")
      .get()
      .then(snapshots => {
        const tokens = [];

        for (const user of snapshots.docs) {
          if (user.data().deviceTokens == undefined) {
            console.error("User has no deviceTokens field. User :: ", user);
            continue;
          }

          console.log("User device tokens", user.data().deviceTokens);
          for (const token of user.data().deviceTokens) {
            tokens.push(token);
          }
          console.log("Pushed user tokens to list");
        }

        console.log("Finished pushing user tokens");

        const payload = {
          notification: {
            title: "Yo bru!",
            body: challenge.ingredient,
            sound: "default"
          }
        };

        console.log("Sending notifications to ", tokens);

        return admin
          .messaging()
          .sendToDevice(tokens, payload)
          .then(response => {
            console.log("Notified users", response);
          })
          .catch(err => {
            console.log("FAILED TO NOTIFY USERS", err);
          });
      });
  });
