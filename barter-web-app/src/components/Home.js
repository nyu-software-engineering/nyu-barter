import React, { Component } from 'react';
import '../App.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import { NavLink } from "react-router-dom";
import PreviewPicture from './PreviewPicture';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCamera } from '@fortawesome/free-solid-svg-icons'
import {faSearch} from '@fortawesome/free-solid-svg-icons'
import {faBars} from '@fortawesome/free-solid-svg-icons'
import {faHome} from '@fortawesome/free-solid-svg-icons'
import {faArchway} from '@fortawesome/free-solid-svg-icons'
import {faHeart} from '@fortawesome/free-solid-svg-icons'
const uuidv4 = require('uuid/v4');


library.add(faCamera)
library.add(faSearch)
library.add(faBars)
library.add(faHome)
library.add(faArchway)
library.add(faHeart)

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
    }
    this.onSubmit = this.onSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
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

    this.setState({dateTime: ''});
    this.setState({descr: ''});
    this.setState({photoUrl: ''});
    this.setState({title: ''});
  }

  componentDidMount = ()=>{
    firebase.auth().onAuthStateChanged(user =>{
      if(user){
        const userRef = firebase.database().ref('users')
        const curUser = user.uid;

        userRef.orderByValue().equalTo(curUser).once("value",snapshot => {
          if (!snapshot.exists()){
            firebase.database().ref('users/' + curUser).child('email').set(user.email);
            firebase.database().ref('users/' + curUser).child('photoURL').set(user.photoURL);
            
          }

        })
      }
      
      this.setState({isSignedIn:!!user});
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
      var descr = barters[k].descr;
      result.push({user, title, photoUrl, descr, _id: k});
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

  addFave = (i) => () => {
    console.log(this.state.userID); 
    const item = this.state.keys[i]; 
    // console.log(item); 
    const uID = item.userID; 
    const userRef = firebase.database().ref(`users/${this.state.userID}/faves`); 
    userRef.child(item._id).set(true, () => {
      console.log('done');
      // console.log("for user=" + uID);
    }); 
    // console.log(this.state.keys[i]);

  }; 

  removeFave = (i) => () => {
    this.setState((prevState) => {
      const nextState = { ...prevState}; 
      nextState.faves.splice(i,1); 
      return nextState; 
    }); 
  }; 

  renderCards () {
    const keys = this.state.keys;
    var counter = 0;
    var label = '';
    var displayDescr = 'displayDescr';
    const itemList = keys.map((itemId,i) => {
      counter += 1;
      var uniqueID = "h" + uuidv4();
      label = "#" + uniqueID;
      return(
        <div className = "col-3">
       <div className ="card" styles="width: 18rem;">
         <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
         <div className ="card-body">
           <a href="#" class="item-title" data-toggle="modal" data-target={label}><h5 className ="card-title">{itemId.title}</h5></a>
           <button className="heart pull-right" key={i} onClick={this.addFave(i)}><FontAwesomeIcon icon="heart" /> </button> 
           <div class="modal fade" id={uniqueID} tabindex="-1" role="dialog" aria-labelledby="descrLabel" aria-hidden="true">
             <div class="modal-dialog" role="document">
               <div class="modal-content">
                 <div class="modal-body">
                   <h4> Would like to trade for - </h4>
                   <h6> {itemId.descr}</h6>
                 </div>
               </div>
             </div>
           </div>
         </div>
       </div>
     </div>
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
              {/* <NavLink to="/" class="navbar-brand">NYU Barter</NavLink> */}
              <a class="navbar-brand homeLink" href="/">NYU Barter</a>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <form class="form-inline my-2 my-lg-0">
                <div className="input-group mb-0 searchBtn">
                  <div className="input-group-prepend">
                    <span className="input-group-text"><FontAwesomeIcon icon="search" /></span>
                  </div>
                </div>
                <input class="form-control mr-sm-2" name = "search" type="search" placeholder="Search" aria-label="Search" />
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
              </form>

                <ul class="navbar-nav ml-auto">
                <li class="nav-item active">
                  <button type="button" class="btn btn-primary m-2" data-toggle="modal" data-target="#addItem">
                    <FontAwesomeIcon icon="camera" /> Add Item
                  </button>
                </li>
                  <li class="nav-item active">
                    <NavLink to="/inventory"> <button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="home" /> My Items</button></NavLink>
                  </li>
                  <li class="nav-item">
                    <NavLink to="/interests"><button className = "btn btn-primary m-2" type="interestedItem"><FontAwesomeIcon icon="archway" /> Interested Items</button></NavLink>
                  </li>
                <li class="nav-item">
                  <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
                </li>
              </ul>

              </div>
            </nav>
          </div>
        </header>
      <div className='container'>
      <div class="modal fade" id="addItem" tabindex="-1" role="dialog" aria-labelledby="addItemLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <p class="heading" id="addItemLabel">
                <strong>Add Item</strong>
              </p>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true" class="white-text">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group row">
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
                </div>
              </div>
              <br />
              <div class="form-group row">
                <div class="col-sm-10">
                  <input type="text" class="form-control" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
                </div>
              </div>
              <label class="upload-group">
                  Upload Image
                <br/>
                <span class="btn btn-default btn-file">
                  <input type="file" class="upload-group" id="file" onChange={(event) => {
                    this.displayPicture(event);
                  }}/>
                </span>
              </label>
              <PreviewPicture photoUrl={this.state.photoUrl}/>
            </div>
            <div class="modal-footer">
              {/* <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button> */}
              <button type="btn btn-info" onClick={this.onSubmit} type="reset" data-dismiss="modal" id="addItemBtn">Add Item to Barter</button>
            </div>
          </div>
        </div>
      </div>
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
  }

  displayPicture(event){
    //new
    let reader = new FileReader();
    let file = event.target.files[0];

    reader.onloadend = ()=>{
      this.setState({
        picture: file,
        photoUrl: reader.result
      });
    };
    reader.readAsDataURL(file);
  }
}

export default Home;
