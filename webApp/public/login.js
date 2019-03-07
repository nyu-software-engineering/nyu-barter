
  // Initialize Firebase
var config = {
  apiKey: "AIzaSyCEHHfBPcz-YPRU7dF2cbMHyaoaJLY3ISk",
  authDomain: "barterapp-ef89b.firebaseapp.com",
  databaseURL: "https://barterapp-ef89b.firebaseio.com",
  projectId: "barterapp-ef89b",
  storageBucket: "barterapp-ef89b.appspot.com",
  messagingSenderId: "935493718813"
};
firebase.initializeApp(config);

var provider = new firebase.auth.FacebookAuthProvider();
firebase.auth().signInWithPopup(provider).then(function(result) {
    // This gives you a Facebook Access Token. You can use it to access the Facebook API.
    var token = result.credential.accessToken;
    // The signed-in user info.
    var user = result.user;
    // ...
  }).catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;
    // The email of the user's account used.
    var email = error.email;
    // The firebase.auth.AuthCredential type that was used.
    var credential = error.credential;
    // ...
  });

module.exports = {


}
