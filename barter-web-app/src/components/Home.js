import React, { Component } from 'react';
import Contact from './Contact.js';
import '../App.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import { NavLink } from "react-router-dom";
import PreviewPicture from './PreviewPicture';
import GetProfileImg from './GetProfileImg';
import Card from './Card';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCamera } from '@fortawesome/free-solid-svg-icons'
import {faSearch} from '@fortawesome/free-solid-svg-icons'
import {faBars} from '@fortawesome/free-solid-svg-icons'
import {faHome} from '@fortawesome/free-solid-svg-icons'
import {faArchway} from '@fortawesome/free-solid-svg-icons'
import {faStore} from '@fortawesome/free-solid-svg-icons'
import {faHeart as solidHeart} from '@fortawesome/free-solid-svg-icons'
import {faHeart as regularHeart} from '@fortawesome/free-regular-svg-icons'
// import './assets/css/fonts.css';

const uuidv4 = require('uuid/v4');

var heartBool = false;

library.add(faCamera)
library.add(faSearch)
library.add(faBars)
library.add(faHome)
library.add(faArchway)
library.add(faStore)
// library.add(faHeart)

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
      userPhoto: '',
      dateTime: '',
      keys: [],
      emails: {},
      category: '',
      toggle: true
    }
    this.onSubmit = this.onSubmit.bind(this);
    this.searchClicked = this.searchClicked.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.faveHandler = this.faveHandler.bind(this);
    this.setPreferences = this.setPreferences.bind(this);
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
      let {isSignedIn, title, descr, photoUrl, picture, userID, category} = this.state;
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
              category,
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

        });

        firebase.database().ref(`users/${curUser}/faves`).on("value", this.updateFaves.bind(this));
        this.setState({userPhoto: user['photoURL']});
      }
      this.setState({isSignedIn:!!user});
      this.setState({userID:user['uid']});

    });
    firebase.database().ref('barters').on('value', (snapshot) => this.gotData(snapshot), this.errData);

    firebase.database().ref('users').on('value', this.makeEmail.bind(this));
  }

  updateFaves(snap){
    const data = snap.val();
    for(let fKey in data){
      const matches = this.state.keys.filter(key => key._id === fKey);
      if(matches.length){
        const index = matches[0].index;
        this.setState(prevState => {
          const nextState = {
            keys: [...prevState.keys]
          };
          nextState.keys[index].fave = data[fKey];
          return nextState;
        });

      }
    }

  }
  makeEmail(data){
    var users = data.val();
    var keys = Object.keys(users);
    const result = {}
    for(var i = 0; i < keys.length;i++){
      var k = keys[i];
      result[k] = users[k].email;
    }
    this.setState({emails: result});
  }
  search(title, search){
    var str = title.toLowerCase();
    var str2 = search.toLowerCase();
    var n1 = str.search(str2);
    var n2 = str2.search(str);
    if(n1 !== -1 || n2 !== -1){
      return true;
    }
    return false;
  }
  gotData(data, oldOrNew, category){
    const search = document.querySelector('#searchText');
    let filter = null;
    if(search){
      filter = search.value;
    }
    var barters = data.val();
    //no matches
    if(!barters){
      this.setState({keys: []});
      return
    }
    var keys = Object.keys(barters);
    const result = []
      for(let i = keys.length-1; i >= 0; i--){
      var k = keys[i];
      if(!filter || this.search(barters[k].title, filter)){
        if(!category || category === 'No Category' || category === barters[k].category){
          var user = barters[k].userID;
          var dateTime = barters[k].dateTime;
          var title = barters[k].title;
          var photoUrl = barters[k].photoUrl;
          var descr = barters[k].descr;
          var fave = false;  // change this
          var index = i;
          // condition called fave
          // fave is true/false, and written as part of this object in the array
          result.push({user, dateTime, title, photoUrl, descr, _id: k, fave, index});
        }
      }
    }
    if(oldOrNew === 'Oldest'){
      result.sort(function(a,b){
        // Turn your strings into dates, and then subtract them
        // to get a value that is either negative, positive, or zero.
        return new Date(a.dateTime) - new Date(b.dateTime);
      });
    }
    this.setState({keys: result});
  }
  searchClicked(e){
    firebase.database().ref('barters').on('value', (snapshot) => this.gotData(snapshot), this.errData);
  }

  errData(err){
    console.log('Error!');
    console.log(err);
  }
  setPreferences(){
    const oldOrNew = document.querySelector("#exampleFormControlSelect1").value;
    const category = document.querySelector("#exampleFormControlSelect2").value;
    firebase.database().ref('barters').on('value', (snapshot) => this.gotData(snapshot, oldOrNew, category), this.errData);
  }
  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  handleFave = (i) => () => {
    const item = this.state.keys[i];
    this.setState(prevState => {
      const nextState = {keys: [...prevState.keys]};
      nextState.keys[i].fave = !item.fave;
      return nextState;
    });
    const uID = item.userID;
    let itemVal = false ;
    const userRef = firebase.database().ref(`users/${this.state.userID}/faves`);
    userRef.child(item._id).once('value').then(function(snapshot) {
       itemVal = snapshot.val();
    }).then(function(){
      if( itemVal === false ||  itemVal === null){
          userRef.child(item._id).set(true, () => {
            console.log('true done');
          });
          item.fave = true;
      }
      else {
        userRef.child(item._id).set(false, () => {
          console.log('false done');
        });
        item.fave = false;
      }
    });
  }

  faveHandler(event) {
    console.log("I am handling fave");
    this.setState((prevState) => ({
        toggle: !prevState.toggle
      })
    );
  }

  addFave = (i) => () => {
    const item = this.state.keys[i];
    const uID = item.userID;
    const userRef = firebase.database().ref(`users/${this.state.userID}/faves`);
    userRef.child(item._id).set(true, () => {
      console.log('done');
    });

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

      var heartBool = false;
      let email = this.state.emails[itemId.user];
      // console.log(itemId);
      return(
        <div className = "col-3" key={itemId}>
       <div className ="card" styles="width: 30rem;">
         <div className = "card-img top cardImg" styles="background-size:500px auto;"><PreviewPicture photoUrl={itemId.photoUrl}/></div>
         <div className ="card-body" >
           <a href="#" class="item-title" data-toggle="modal" data-target={label} ><h5 className ="card-title" styles="padding-top: 30%;">{itemId.title}</h5></a>
           <button className="heart pull-right" styles="position: relative; display:inline-block;" key={i} onClick={this.handleFave(i)}><FontAwesomeIcon icon={itemId.fave ? solidHeart : regularHeart} /> </button>
           <div class="modal fade" id={uniqueID} tabindex="-1" role="dialog" aria-labelledby="descrLabel" aria-hidden="true">
             <div class="modal-dialog" role="document">
               <div class="modal-content">
                 <div class="modal-body">
                   <div className = "card-img top cardImg" styles="background-size:500px auto;"><PreviewPicture photoUrl={itemId.photoUrl}/></div>
                   <h4> Would like to trade for - </h4>
                   <h6> {itemId.descr}</h6>
                   <Contact email={email}/>
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
          <div class="barterNav" styles="background-color: rgb(255, 63, 85);">
            <nav class="navbar navbar-expand-lg" >
              {/*<a class="navbar-brand homeLink" href="/">NYU Barter</a>*/}
              <GetProfileImg userPhoto={this.state.userPhoto}/>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <div class="form-inline my-2  my-lg-0">
                <div className="input-group mb-0 searchBtn">
                    <input id="searchText" class="form-control mr-sm-2" name = "search" type="search" placeholder="Search" aria-label="Search" />
                    <span className="input-group-text "><FontAwesomeIcon icon="search" /></span>
                <button class="btn btn-outline-success my-2 my-sm-0" onClick={this.searchClicked} type="button">Search</button>
                </div>
              </div>

                <ul class="navbar-nav ml-auto">
                <li class="nav-item active">
                  <button type="button" class="btn btn-primary m-2" data-toggle="modal" data-target="#addItem">
                    <FontAwesomeIcon icon="camera" /> Add Item
                  </button>
                </li>
                  <li class="nav-item active">
                    <NavLink to="/"> <button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="home" /> Home</button></NavLink>
                  </li>
                  <li class="nav-item active">
                    <NavLink to="/inventory"> <button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="archway" /> My Posts</button></NavLink>
                  </li>
                  <li class="nav-item">
                    <NavLink to="/interests"><button className = "btn btn-primary m-2" type="interestedItem"><FontAwesomeIcon icon={solidHeart} /> Favorites</button></NavLink>
                  </li>
                <li class="nav-item">
                  <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
                </li>
              </ul>

              </div>
            </nav>
          </div>
          </div>
        </header>
      <div className='container'>
      <div className="modal fade" id="addItem" tabindex="-1" role="dialog" aria-labelledby="addItemLabel" aria-hidden="true">
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
              Category
              <div class="form-group row">
                <div class="col-sm-10">
                    <select name="category" class="form-control" onChange={this.handleChange} value={this.state.category}>
                      <option name="Electronics">Electronics</option>
                      <option name="Fashion">Fashion</option>
                      <option name="Home">Home</option>
                      <option name="Sporting">Sporting</option>
                      <option name="School">School</option>
                      <option name="Music">Music</option>
                      <option name="Other">Other</option>
                    </select>
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
      <br></br>
      <form>
        <div class="form-row">
        <div class="form-group">
          <select class="form-control" id="exampleFormControlSelect1">
          <option>Latest</option>
          <option>Oldest</option>
          </select>
        </div>
          <div class="form-group">
            <select class="form-control" id="exampleFormControlSelect2">
            <option>No Category</option>
            <option>Electronics</option>
            <option>Fashion</option>
            <option>Home</option>
            <option>Sporting</option>
            <option>School</option>
            <option>Music</option>
            <option>Other</option>
            </select>
          </div>
          <div class="form-group">
            <button type="button" class="btn btn-primary" onClick={this.setPreferences}>Set Preferences</button>
          </div>
        </div>
      </form>
        <section className='display-item'>
          <div className='wrapper'>
            <div className="row">
              {this.renderCards()}
              {/* {
                 this.state.keys.map(key => <HomeCard data={key} />)
              } */}
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
