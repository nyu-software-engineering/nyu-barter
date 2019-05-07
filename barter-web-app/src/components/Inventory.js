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
import {faTrashAlt} from '@fortawesome/free-solid-svg-icons'
import {faHeart as regularHeart} from '@fortawesome/free-regular-svg-icons'
import {faHeart as solidHeart} from '@fortawesome/free-solid-svg-icons'
const uuidv4 = require('uuid/v4');



class Inventory extends React.Component {
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
      category: '',
      dateTime: '',
      keys: [],
    }
    this.onSubmit = this.onSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
  }
  gotData(data){
    if(firebase.auth().currentUser!=null){
      var curUser = firebase.auth().currentUser.uid;
      //console.log(data.val())
      var barters = data.val();
      var keys = Object.keys(barters);
      const result = []
      for(var i = 0; i < keys.length;i++){

        var k = keys[i];
        var itemNum = k+'';
        var user = barters[k].userID;
        var title = barters[k].title;
        var descr = barters[k].descr;
        var photoUrl = barters[k].photoUrl;

        if(user==curUser){
          result.push({user, title,descr, photoUrl, itemNum});
        }
      }
      this.setState({keys: result});
    }
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
    this.setState({category: ''});
  }

  errData(err){
    console.log('Error!');
    console.log(err);
  }

  componentDidMount(){
    var run = false;
    firebase.auth().onAuthStateChanged(user =>{
      if(user){
        this.setState({userPhoto: user['photoURL']});
        this.setState({userID:user['uid']});
        this.setState({userEmail: user.email});
        this.setState({userName: user.displayName});
      }
      this.setState({isSignedIn:!!user});

      firebase.database().ref('barters').on('value', this.gotData.bind(this), this.errData);
    });


  }
  componentWillUnmount(){
  }

  handleRemove(itemRef) {
    var ref = firebase.database().ref('barters/' + itemRef);
    ref.remove();
  };

  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  renderCards () {
    const keys = this.state.keys;
    const itemList = keys.map(itemId => {
      console.log(itemId.itemNum);
      return(
        <div className = "col-3">
        <div className ="card" styles="width: 18rem;">
          <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
          <div className ="card-body">
            <a href="#" class="item-title" data-toggle="modal" data-target="#displayDescr"><h5 className ="card-title">{itemId.title}</h5></a>
            <button className="heart pull-right" styles="position: relative; display:inline-block;" onClick={()=>{this.handleRemove(itemId.itemNum)}}>Delete </button>
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
                    <li>
                      <NavLink to="/inventory"><button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="archway" /> My Posts </button></NavLink>
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
            <h1 className="pageText">My Posts</h1>
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
          <div className='wrapper'>
            <div className="row">
              {this.renderCards()
                //this.state.keys.map(key => <Card data={key} />)
              }
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

export default Inventory;
