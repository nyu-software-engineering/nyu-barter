import React, { Component } from 'react';
import '../App.css';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import { NavLink } from "react-router-dom";
import PreviewPicture from './PreviewPicture';
import Item from './Item';
import 'bootstrap/dist/js/bootstrap.bundle.min';
// import 'font-awesomenpm i --save @fortawesome/react-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCamera } from '@fortawesome/free-solid-svg-icons'
import {faSearch} from '@fortawesome/free-solid-svg-icons'
import {faBars} from '@fortawesome/free-solid-svg-icons'
// import Home from './components/Home';
const uuidv4 = require('uuid/v4');

library.add(faCamera)
library.add(faSearch)
library.add(faBars)

const config = {
    apiKey: process.env.REACT_APP_FIREBASE_KEY,
    authDomain: process.env.REACT_APP_FIREBASE_DOMAIN,
    databaseURL: process.env.REACT_APP_FIREBASE_DATABASE,
    projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
    storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.REACT_APP_FIREBASE_SENDER_ID
};

const app = firebase.initializeApp(config);
const base = Rebase.createClass(app.database());

class Home extends React.Component {
  constructor() {
    super();
    this.ref = firebase.database().ref('barters');
    this.state = {
      isSignedIn: false,
      title: '',
      descr: '',
      photoUrl: null,
      picture: null,
      userID: '',
      dateTime: '',
      keys: [],
      showBar: false
    }
    this.onSubmit = this.onSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.addItem = this.addItem.bind(this);
    this.renderItem = this.renderItem.bind(this);
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

  onSubmit(event){
      
      var newPostKey = firebase.database().ref().child('barters').push().key;

      let {isSignedIn, title, descr, photoUrl, picture, userID} = this.state;
      var storageRef = firebase.storage().ref();
      var uniqueID = uuidv4();
      console.log(uniqueID)
      var itemPhotosRef = storageRef.child(`itemPhotos/${uniqueID}`);
      let picUrl = null;
      itemPhotosRef.put(picture).then((snapshot)=> {
        snapshot.ref.getDownloadURL().then((downloadURL) =>{
          photoUrl = downloadURL;
          firebase.database().ref('barters/' + newPostKey).set({
              dateTime: firebase.database.ServerValue.TIMESTAMP,
              descr,
              photoUrl,
              title,
              userID,
          });
        })
      });

      firebase.database().ref('users/' + userID).child('myItems');
      firebase.database().ref('users/' + userID + '/myItems').push(newPostKey);

    this.setState({dateTime: '', descr: '', photoUrl: '', title: ''});
  }

  componentDidMount = ()=>{
    firebase.auth().onAuthStateChanged(user =>{
      
      if(user){
        const userRef = firebase.database().ref('users')
        const curUser = user.uid;
        const UserEmail = user.email;
        const photoURL = user.photoURL;
        
        userRef.orderByValue().equalTo(curUser).once("value",snapshot => {
          if (!snapshot.exists()){
            userRef.child(curUser)
            firebase.database().ref('users/' + curUser).child('email').set(UserEmail);
            firebase.database().ref('users/' + curUser).child('photoURL').set(photoURL);
          }
            
        })
      }
      
      this.setState({isSignedIn:!!user})
      this.setState({userID:user['uid']});

    });
    firebase.database().ref('barters').on('value', this.gotData.bind(this), this.errData);
  }

  gotData(data){
    var barters = data.val();
    var keys = Object.keys(barters);
    const result = []
    for(var i = 0; i < keys.length;i++){
      var k = keys[i];
      var user = barters[k].userID;
      var title = barters[k].title;
      var photoUrl = barters[k].photoUrl;
      result.push({user, title, photoUrl});
    }
    this.setState({keys: result});
  }

  errData(err){
    console.log('Error!');
    console.log(err);
  }

  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  addItem(){
    this.setState({showBar: true}); 
  }

  renderItem(){
    return this.state.showBar ? <Item/> : null;
  }

  renderCards () {
    const keys = this.state.keys;
    const itemList = keys.map(itemId => {
      return(

       
        <div className = "col-3"> 
          <div className ="card" styles="width: 18rem;">
            <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
            <div className ="card-body">
              <h5 className ="card-title">{itemId.title}</h5>
            </div>
          </div>
        </div>
        
    //  
      )
    });
    return itemList;
  }

  render() {

    return (
      
      <div className='home'>
      {this.state.isSignedIn ? (
          <span>
          <header>
          <div className='wrapper'>
            <script src="https://www.gstatic.com/firebasejs/5.8.4/firebase.js"></script>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
              <a class="navbar-brand" href="#">Barter</a>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <form class="form-inline my-2 my-lg-0">
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><FontAwesomeIcon icon="search" /></span>
                    </div>
                    <input class="form-control mr-sm-2" name = "search" type="search" placeholder="Search" aria-label="Search" />
                    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                  </div>
                </form>
                <ul class="navbar-nav ml-auto">
                  
                  {/* add item button */}
                  <li class="nav-item active">
                    <button type="button" class="btn btn-primary m-2" data-toggle="modal" data-target="#addItem">
                    <p> Add Item <FontAwesomeIcon icon="camera" /></p>
                    </button>
                    <Item />
                  </li>
                  
                  {/* signout button */}
                  <li class="nav-item">
                    <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
                  </li>

                  {/* drop down menu for  */}
                  <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      <span> <FontAwesomeIcon icon="bars" /></span>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                      <a class="dropdown-item" href="#">
                        <li class="nav-item active">
                        <NavLink to="/inventory"> <button className = "btn btn-primary m-2 " type="myItems">My Items</button></NavLink>
                        </li>
                      </a>
                      <a class="dropdown-item" href="#">
                        <li class="nav-item">
                        <NavLink to="/interests"><button className= "btn btn-primary m-2" type="interestedItem">Interested Items</button></NavLink>
                          </li>
                        </a>
                      </div>
                    </li>
                  </ul>
                </div>
              </nav>
            </div>
          </header>
          <div className='container'>
            <section className='display-item'>
              <div className='wrapper'>
                <div className="row">
                  {this.renderCards()}
                </div>
                
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
  };

}

export default Home;
