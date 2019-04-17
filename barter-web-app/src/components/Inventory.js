import React, { Component } from 'react';
import firebase from 'firebase';
import Rebase from 're-base';
import PreviewPicture from './PreviewPicture';


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
      var descr = barters[k].descr;
      var photoUrl = barters[k].photoUrl;
      result.push({user, title,descr, photoUrl});
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

  renderCards () {
    const keys = this.state.keys;
    const itemList = keys.map(itemId => {
      console.log(itemId.title, itemId.descr);
      return(
        <div className = "col-3">
        <div className ="card" styles="width: 18rem;">
          <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
          <div className ="card-body">
            <a href="#" class="item-title" data-toggle="modal" data-target="#displayDescr"><h5 className ="card-title">{itemId.title}</h5></a>
            <div class="modal fade" id="displayDescr" tabindex="-1" role="dialog" aria-labelledby="descrLabel" aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <div class="modal-body" id="descrLabel">
                    <h4> Would like to trade for - </h4>
                    <h6> {itemId.descr}  </h6>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      )
    });
    return itemList;
  }

  render() {

    //   const keys = this.state.keys;
    //   const itemList = keys.map(itemId => {
    //     return(
    //       <div className = "col-3">
    //    <div className ="card" styles="width: 18rem;">
    //      <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
    //      <div className ="card-body">
    //        <a href="#" class="item-title" data-toggle="modal" data-target="#displayDescr"><h5 className ="card-title">{itemId.title}</h5></a>
    //        <div class="modal fade" id="displayDescr" tabindex="-1" role="dialog" aria-labelledby="descrLabel" aria-hidden="true">
    //          <div class="modal-dialog" role="document">
    //            <div class="modal-content">
    //              <div class="modal-body" id="descrLabel">
    //                <h4> Would like to trade for - </h4>
    //                <h6> {itemId.descr}  </h6>
    //              </div>
    //            </div>
    //          </div>
    //        </div>
    //      </div>
    //    </div>
    //  </div>
    //     )
    //   });

      return (
        
        <div> 
          <header className="InventoryHeader">
            <h1 className="InvText">Inventory</h1>
          </header>
          <div className='container'>
            <section className='display-item'>
              <div className='wrapper'>
                <div className="row">
                  {this.renderCards()}
                </div>
              </div>
          </section>
        </div>
        </div>
      );
   }
}

export default Inventory;
