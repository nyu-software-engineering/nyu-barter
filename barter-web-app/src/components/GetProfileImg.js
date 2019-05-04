import React from 'react';
import firebase from 'firebase';

const GetProfileImg= (props) =>{
    const {userPhoto} = props;
    const {userEmail} = props; 
    console.log("email is = "); 
    console.log(userEmail);
    return(

      <div> 
        <button type="button" data-toggle="collapse" data-target="#userProfile" aria-expanded="false" aria-controls="userProfile">
            <img id="profileImg" src={userPhoto}/>
        </button>

          <div class="profile"> 
          <div class="collapse" id="userProfile">
            <div class="card card-body">
              {userEmail}
              <button className = "btn btn-primary m-2" onClick={() => firebase.auth().signOut()}>Logout</button>
            </div>
          </div>
        </div> 
        </div>
     
    );
};
export default GetProfileImg;



