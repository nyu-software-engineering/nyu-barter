import React from 'react';

const GetProfileImg= (props) =>{
    const {userPhoto} = props;
    return(
      <img id="profileImg" src={userPhoto}/>
    );
};
export default GetProfileImg;
