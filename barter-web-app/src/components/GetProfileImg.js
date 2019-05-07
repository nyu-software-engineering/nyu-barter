import React from 'react';
import firebase from 'firebase';
import '../App.css';

const GetProfileImg= (props) =>{
    const {userPhoto} = props;
    const {userEmail} = props;
    const {userName} = props;

    return(

      <div class="dropdown" id="profileDiv">
          <img id="profileImg" src={userPhoto} class="dropBtn"/>
         {/* <button class="dropbtn">Dropdown</button> */}
  <div class="dropdown-content">
  {userName}
  <br></br>
  {userEmail}

              <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
      </div>
      </div>


    );
};
export default GetProfileImg;
