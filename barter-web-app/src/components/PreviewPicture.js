import React from 'react';

const PreviewPicture = (props) =>{
    const {photoUrl} = props;
    return(
      <img height="100px" src={photoUrl}/>
    );
};

export default PreviewPicture;
