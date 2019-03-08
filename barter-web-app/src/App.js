import React, { Component } from 'react';
import './App.css';
import firebase from './firebase.js';

class App extends Component {
  constructor() {
    super();
    this.state = {
      title: '',
      descr: '',
      photoUrl: '',
      username: '',
      dateTime: ''
    }
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }

  render() {
    return (
      <div className='app'>
        <header>
            <div className='wrapper'>
              <h1>NYU Barter</h1>
              <input type="text" name="search" placeholder="Search for items" />
                <button type="myItems">My Items</button>
                <button type="interestedItems">Interested Items</button>
                <button class="logout">Logout</button>
            </div>
        </header>
        <div className='container'>
          <section className='add-item'>
              <form>
                <input type="text" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
                <input type="text" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
                <input type="text" name="photoUrl" placeholder="Add a picture of your item" onChange={this.handleChange} value={this.state.photoUrl} />
                <button>Add Item to Barter</button>
              </form>
          </section>
          <section className='display-item'>
            <div className='wrapper'>
              <ul>
              
              </ul>
            </div>
          </section>
        </div>
      </div>
    );
  }
}
export default App;