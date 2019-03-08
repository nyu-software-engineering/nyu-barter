import firebase from 'firebase'

const config = {
    apiKey: "AIzaSyCEHHfBPcz-YPRU7dF2cbMHyaoaJLY3ISk",
    authDomain: "barterapp-ef89b.firebaseapp.com",
    databaseURL: "https://barterapp-ef89b.firebaseio.com",
    projectId: "barterapp-ef89b",
    storageBucket: "barterapp-ef89b.appspot.com",
    messagingSenderId: "935493718813"
};

firebase.initializeApp(config);
export default firebase;