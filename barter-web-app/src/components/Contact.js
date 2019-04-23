import React, { Component } from 'react';

class Contact extends React.Component{
  render(){
    return(
      <div>
      <p>Contact me at {this.props.email || 'email not found'}</p>
      </div>
    )
  }
}

export default Contact;
