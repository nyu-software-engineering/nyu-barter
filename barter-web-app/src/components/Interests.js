
import React, { Component } from 'react';
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
import {faHeart} from '@fortawesome/free-solid-svg-icons'
import {faHeart as solidHeart} from '@fortawesome/free-solid-svg-icons'
import Contact from './Contact.js';
const uuidv4 = require('uuid/v4');

class Interests extends React.Component {
  constructor() {
    super();
    this.state = {
      items : [],
      isSignedIn: false,
      title: '',
      descr: '',
      photoUrl: null,
      picture: null,
      userID: '',
      userPhoto: '',
      dateTime: '',
      category: '',
      emails: {},
    }
    this.handleChange = this.handleChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }


  errData(err){
    console.log('Error!');
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
    this.setState({category: ''});
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

  componentDidMount(){

    firebase.auth().onAuthStateChanged(user =>{
      //Start change
      if(user){
        const userRef = firebase.database().ref('barterUsers')
        const curUser = user.uid;

        userRef.orderByValue().equalTo(curUser).once("value",snapshot => {
          if (!snapshot.exists()){
            //userRef.child('userID').set(curUser)
            userRef.child(curUser)
          }

        })
        this.setState({userPhoto: user['photoURL']});
        this.setState({userEmail: user.email});
        this.setState({userName: user.displayName});
        this.setState({userID:user['uid']});
      }
      //End changes
      this.setState({isSignedIn:!!user});


      firebase.database().ref(`users/${user.uid}/faves`).on('value', this.getFaves);
    });
    firebase.database().ref('users').on('value', this.makeEmail.bind(this));

  }
  componentWillUnmount(){
  }


  handleChange = (e) => {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  getFaves = (snap) => {
    var faves = snap.val();
    if(!faves) {
      return;
    }
    var keys = Object.keys(faves);
    var values = Object.values(faves);

    this.setState({
      items: []
    });
    keys.forEach(key => {

      if(faves[key] === true ){
        firebase.database().ref(`barters/${key}`).on('value', (snap) => {
          const val = snap.val();
          this.setState(prevState => {
            const nextState = {...prevState};

            nextState.items.push(val);
            return nextState;
          });
        });
    }

      // look for `users/${userID}/faves/${key}
      // using that value, set local state favorite to true or false for this item
    });

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

  renderCards () {
    const keys = this.state.items;
    var counter = 0;
    var label = '';
    var displayDescr = 'displayDescr';
    const itemList = keys.map((itemId,i) => {
      counter += 1;
      var uniqueID = "h" + uuidv4();
      label = "#" + uniqueID;

      let email = this.state.emails[itemId.userID];
      return(
        <div className = "col-sm-4" key={itemId._id}>
          <div className ="card" styles="width: 30rem;">
            <img class="card-img-top img-fluid" id="itemPhoto" src={itemId.photoUrl} />
              <div className ="card-body" >
                <a href="#" class="item-title" data-toggle="modal" data-target={label} ><h5 className ="card-title" styles="padding-top: 30%;">{itemId.title}</h5></a>

           <div class="modal fade" id={uniqueID} tabindex="-1" role="dialog" aria-labelledby="descrLabel" aria-hidden="true">
             <div class="modal-dialog" role="document">
               <div class="modal-content">
                 <div class="modal-body">
                   <div className = "card-img top cardImg" styles="background-size:500px auto;"><PreviewPicture photoUrl={itemId.photoUrl}/></div>
                   <h4> Description </h4>
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
        <div>
        {this.state.isSignedIn ? (
          <span>
          <header>
          <div className='wrapper'>
            <script src="https://www.gstatic.com/firebasejs/5.8.4/firebase.js"></script>

            <div class="barterNav">
            <nav class="navbar navbar-expand-lg navbar-light" >
              <a class="navbar-brand homeLink"><img id="logo" src="/logo.png"/></a>

              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <div class="form-inline my-2  my-lg-0">
                <div className="input-group mb-3 search-box">
                    <input id="searchText" class="form-control mr-sm-2" name = "search" type="search" placeholder="Search" aria-label="Search" />
                    <div class="input-group-append">
                    <button className="input-group-text" onClick={this.searchClicked} type="button"><FontAwesomeIcon icon="search" /></button>
                    </div>
                {/* <button class="btn btn-outline-success my-2 my-sm-0" onClick={this.searchClicked} type="button">Search</button> */}
                </div>

              </div>



                  <ul class="navbar-nav ml-auto">
                  <li>
                    <button type="button" class="btn btn-primary m-2" data-toggle="modal" data-target="#addItem">
                      <FontAwesomeIcon icon="camera" /> Add Item
                    </button>
                  </li>
                    <li>
                      <NavLink to="/">  <button className = "btn btn-primary m-2 " type="myItems"> <FontAwesomeIcon icon="home" /> Home</button></NavLink>
                    </li>
                    <li >
                      <NavLink to="/inventory"><button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="archway" /> My Posts</button></NavLink>
                    </li>
                    <li>
                      <NavLink to="/interests"><button className = "btn btn-primary m-2" type="interestedItem"><FontAwesomeIcon icon={solidHeart} /> Favorites</button></NavLink>
                    </li>

                    <GetProfileImg userPhoto={this.state.userPhoto} userEmail={this.state.userEmail} userName = {this.state.userName}/>

                </ul>



              </div>
            </nav>
            <hr/>
          </div>
          </div>
        </header>
        <header className="pageHeader">
            <h1 className="pageText">My Favorites</h1>
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
                Item
                    <input type="text" class="form-control addItem" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
                </div>
              </div>

              <div class="form-group row">

                <div class="col-sm-10">
                 Description
                  <input type="text" class="form-control addItem" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
                </div>
              </div>

              <div class="form-group row">
                <div class="col-sm-10">
                Category
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
        <section className='display-item'>
          <div className='container-fluid'>
            <div className="row">
              { this.renderCards() }

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
}



export default Interests;
