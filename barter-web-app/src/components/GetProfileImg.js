import React from 'react';
import firebase from 'firebase';
import '../App.css';

const GetProfileImg= (props) =>{
    const {userPhoto} = props;
    const {userEmail} = props;
    const {userName} = props;

    return(

      // <div>
      //   <button type="button" data-toggle="collapse" data-target="#userProfile" aria-expanded="false" aria-controls="userProfile">
      //       <img id="profileImg" src={userPhoto}/>
      //   </button>

      //     <div class="profile">
      //     <div class="collapse" id="userProfile">
      //       <div class="card card-body">
      //         {userEmail}
      //         <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
      //       </div>
      //     </div>
      //   </div>
      //   </div>

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
