
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");


firebase.initializeApp({
  apiKey: "AIzaSyAErOr6cFrXbm_9SF_MamyXDHhiKOnCNXc",

  authDomain: "shriumeshsonsapp.firebaseapp.com",

  projectId: "shriumeshsonsapp",

  storageBucket: "shriumeshsonsapp.appspot.com",

  messagingSenderId: "207694629480",

  appId: "1:207694629480:web:18814847f52006250bc9dd",

  measurementId: "G-5E9TKFGBTX"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
