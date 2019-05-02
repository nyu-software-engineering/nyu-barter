
import React, { Component } from 'react';
import '../App.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import { NavLink } from "react-router-dom";
import PreviewPicture from './PreviewPicture';
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
const uuidv4 = require('uuid/v4');

class Interests extends React.Component {
  constructor() {
    super();
    this.state = {
      items : []
    }
    this.handleChange = this.handleChange.bind(this);
  }


  errData(err){
    console.log('Error!');
    console.log(err);
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
      }
      //End changes
      this.setState({isSignedIn:!!user});
      this.setState({userID:user['uid']});

      firebase.database().ref(`users/${user.uid}/faves`).on('value', this.getFaves);
      console.log("id");
      console.log(this.state.userID);
    });


  }
  componentWillUnmount(){
  }

  handleChange = (e) => {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  getFaves = (snap) => {

    console.log("logging snap");
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
      // console.log(key);
        firebase.database().ref(`barters/${key}`).on('value', (snap) => {
          const val = snap.val();
          console.log("this val is= " + val);
          this.setState(prevState => {
            const nextState = {...prevState};

            nextState.items.push(val);
            console.log(nextState);
            return nextState;
          });
        });
    }

      // look for `users/${userID}/faves/${key}
      // using that value, set local state favorite to true or false for this item
    });

  }
  renderCards () {
    const items = this.state.items;
    var counter = 0;
    var label = '';
    var displayDescr = 'displayDescr';
    const itemList = items.map((itemId,i) => {
      counter += 1;
      var uniqueID = "h" + uuidv4();
      label = "#" + uniqueID;
      return(
        <div className = "col-3">
       <div className ="card" styles="width: 18rem;">
         <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
         <div className ="card-body">
           <a href="#" class="item-title" data-toggle="modal" data-target={label}><h5 className ="card-title">{itemId.title}</h5></a>
           {/* <button className="heart pull-right" key={i} onClick={this.addFave(i)}><FontAwesomeIcon icon="heart" /> </button>  */}
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
        <div>

        <span>
        <header>
        <div className='wrapper'>
          <script src="https://www.gstatic.com/firebasejs/5.8.4/firebase.js"></script>

          <nav class="navbar navbar-expand-lg navbar-light bg-light">
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
              {/* <li class="nav-item active">
                <button type="button" class="btn btn-primary m-2" data-toggle="modal" data-target="#addItem">
                  <FontAwesomeIcon icon="camera" /> Add Item
                </button>
              </li> */}
                <li class="nav-item active">
                  <NavLink to="/inventory"> <button className = "btn btn-primary m-2 " type="myItems"><FontAwesomeIcon icon="home" /> My Items</button></NavLink>
                </li>
                <li class="nav-item">
                  <NavLink to="/interests"><button className = "btn btn-primary m-2" type="interestedItem"><FontAwesomeIcon icon="archway" /> Interested Items</button></NavLink>
                </li>
              <li class="nav-item">
                <button className = "btn btn-primary m-2" >Logout</button>
              </li>
            </ul>

            </div>
          </nav>
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
            {/* {this.renderCards()} */}
            {this.state.items.length ? this.state.items.map(key => <Card data={key} />): <h1>No Faves....</h1>}
          </div>
        </div>
      </section>
    </div>
        </span>
      </div>
      );
   }
}



export default Interests;
