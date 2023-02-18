import { initializeApp } from "firebase/app";
import { getMessaging } from "firebase/messaging/sw";

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
const firebaseApp = initializeApp({

  apiKey: "AIzaSyAErOr6cFrXbm_9SF_MamyXDHhiKOnCNXc",

  authDomain: "shriumeshsonsapp.firebaseapp.com",

  projectId: "shriumeshsonsapp",

  storageBucket: "shriumeshsonsapp.appspot.com",

  messagingSenderId: "207694629480",

  appId: "1:207694629480:web:18814847f52006250bc9dd",

  measurementId: "G-5E9TKFGBTX"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = getMessaging(firebaseApp);
