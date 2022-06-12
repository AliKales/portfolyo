const functions = require("firebase-functions");
const admin = require("firebase-admin");

const Firestore = require('@google-cloud/firestore');
const { object } = require("firebase-functions/v1/storage");
const firestore = new Firestore();

admin.initializeApp();

const db = admin.firestore();

exports.getUserWithPassword = functions.https.onCall(async (data, context) => {
    try {
        var response = await db.collection("users").doc(data.userID).get();

        if (response.get("passwordForPrivacy") == data.passwordForPrivacy) {
            return response.data();
        } else {
            return { 'error-code': 'wrong-password', 'error-message': 'Wrong password!' };
        }
    } catch (error) {
        return { 'error-code': 'unexpected-error', 'error-message': `${error}` };
    }
});
