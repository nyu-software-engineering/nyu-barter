import React, { Component } from 'react';

class Contact extends React.Component{
  constructor(){
    super();
    this.sendMail = this.sendMail.bind(this);
  }
  sendMail(){
    window.open(`mailto:${this.props.email}`);
  }
  render(){
    return(
      <div>
      Contact: <button class="btn btn-primary" onClick={this.sendMail}> {this.props.email || 'email not found'}</button>
      </div>
    )
  }
}

export default Contact;
