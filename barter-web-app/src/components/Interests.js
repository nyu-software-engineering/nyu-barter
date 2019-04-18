
import React, { Component } from 'react';
import firebase from 'firebase';
import Rebase from 're-base';
import PreviewPicture from './PreviewPicture';
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
    var keys = Object.keys(faves); 

    keys.forEach(key => {
      // console.log(key);
      firebase.database().ref(`barters/${key}`).on('value', (snap) => {
        const val = snap.val();

        this.setState(prevState => {
          const nextState = {...prevState};

          nextState.items.push(val);
          console.log(nextState);
          return nextState;
        });
      });
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
          <header>
            <h1>My Favorites</h1>
          </header>
          <div className='container'>
            <section className='display-item'>
              <div className='wrapper'>
                <div className='row'>
                  {this.renderCards()}
                </div> 
              </div>
            </section>
          </div>
        </div>
      );
   }
}



export default Interests;
