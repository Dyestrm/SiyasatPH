importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyDHNlHAB_bYA1-P5IB9BnSYrcfVZZlsKIE',
  authDomain: 'siyasatph.firebaseapp.com',
  projectId: 'siyasatph',
  storageBucket: 'siyasatph.firebasestorage.app',
  messagingSenderId: '447455254557',
  appId: '1:447455254557:web:5f3a735958b35dbba68ef4'
});

const messaging = firebase.messaging();
