import React, { Component } from 'react';
import './App.css';
import firebase from 'firebase';
// import { provider, auth } from './firebase';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";

const config = {
    apiKey: "AIzaSyCEHHfBPcz-YPRU7dF2cbMHyaoaJLY3ISk",
    authDomain: "barterapp-ef89b.firebaseapp.com",
    databaseURL: "https://barterapp-ef89b.firebaseio.com",
    projectId: "barterapp-ef89b",
    storageBucket: "barterapp-ef89b.appspot.com",
    messagingSenderId: "935493718813"
};

firebase.initializeApp(config)

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      title: '',
      descr: '',
      photoUrl: '',
      username: '',
      dateTime: ''
    }
    this.handleChange = this.handleChange.bind(this);
  }
  state={
    isSignedIn: false
  }
  uiConfig = {
    signInFlow: "popup",
    signInOptions: [
        firebase.auth.FacebookAuthProvider.PROVIDER_ID,
        firebase.auth.GoogleAuthProvider.PROVIDER_ID,
        firebase.auth.EmailAuthProvider.PROVIDER_ID
    ],
    callbacks: {
      signInSuccess: () => false
    }
  }
  componentDidMount = ()=>{

    firebase.auth().onAuthStateChanged(user =>{
      this.setState({isSignedIn:!!user})
    });
  }

  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  render() {
    return (
      <div className='app'>
      {this.state.isSignedIn ? (
          <span>
          <header>
          <div className='wrapper'>
            <h1>NYU Barter</h1>
            <script src="https://www.gstatic.com/firebasejs/5.8.4/firebase.js"></script>
            <script src="login.js"></script>
            <input type="text" name="search" placeholder="Search for items" />
              <form id="form1" >
              <button type="myItems">My Items</button>
              <button type="interestedItems">Interested Items</button>
              <button onClick={() => firebase.auth().signOut()}>Logout</button>
              </form>
          </div>
      </header>
      <div className='container'>
        <section className='add-item'>
            <form>
              <input type="text" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
              <input type="text" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
              <input type="text" name="photoUrl" placeholder="Add a picture of your item" onChange={this.handleChange} value={this.state.photoUrl} />
              <button>Add Item to Barter</button>
            </form>
        </section>
        <section className='display-item'>
          <div className='wrapper'>
            <ul>

            </ul>
          </div>
        </section>
      </div>
          </span>
        ) : (
          <StyledFirebaseAuth class="LoginButtons"
            uiConfig={this.uiConfig}
            firebaseAuth={firebase.auth()}
          />
        )}
      </div>
    );
  }
}
export default App;
