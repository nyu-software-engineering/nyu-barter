import React, { Component } from 'react';

class Contact extends React.Component{
  render(){
    return(
      <div>
      <p>Contact me at {this.props.email}</p>
      </div>
    )
  }
}

export default Contact;
