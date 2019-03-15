import React, { Component } from 'react';
import firebase from 'firebase';
import Rebase from 're-base';


class Inventory extends React.Component {
  constructor() {
    super();
    this.state = {
      keys : []
    }
    this.handleChange = this.handleChange.bind(this);
  }
  gotData(data){
    //console.log(data.val())
    var barters = data.val();
    var keys = Object.keys(barters);
    const result = []
    for(var i = 0; i < keys.length;i++){
      var k = keys[i];
      var user = barters[k].userID;
      var title = barters[k].title;
      result.push({user, title});
    }
    this.setState({keys: result});
  }

  errData(err){
    console.log('Error!');
    console.log(err);
  }

  componentDidMount(){
  firebase.database().ref('barters').on('value', this.gotData.bind(this), this.errData);

  }
  componentWillUnmount(){
  }

  handleChange(e) {
    this.setState({
      [e.target.name]: e.target.value
    });
  }
  render() {

      const keys = this.state.keys;
      const itemList = keys.map(itemId => {
        return(
          <li>{itemId.title}</li>
        )
      });

      return (
        <div>
          <header>
            <h1>Inventory</h1>
          </header>
          <div className='container'>
            <section className='display-item'>
              <div className='wrapper'>
                <ul id="itemlist">
                  {itemList}
                </ul>
              </div>
            </section>
          </div>
        </div>
      );
   }
}

export default Inventory;
