import React, { Component } from 'react';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import Home from './components/Home';
import Interests from './components/Interests';
import Inventory from './components/Inventory';
import { BrowserRouter, Route } from "react-router-dom";

class App extends Component{

  render(){
    return (
      <BrowserRouter>
        <div>
          <Route path="/" component={Home} exact/>
          <Route path="/interests" component={Interests}/>
          <Route path="/inventory" component={Inventory}/>
        </div>
      </BrowserRouter>
    )
  }
}


export default App;
