import React, { Component } from 'react';
import '../App.css';
import firebase from 'firebase';
import Rebase from 're-base';
import StyledFirebaseAuth from "react-firebaseui/StyledFirebaseAuth";
import { NavLink } from "react-router-dom";
import PreviewPicture from './PreviewPicture';

class Item extends Component {
    constructor (props) {
        super(props);
        this.state = {
            isSignedIn: false,
            title: '',
            descr: '',
            photoUrl: null,
            userID: '',
            dateTime: '',
            keys: [],
        };
        this.handleChange = this.handleChange.bind(this);
        this.addPicture = this.addPicture.bind(this);
        this.onSubmit = this.onSubmit.bind(this);
    }

    handleChange(e) {
        this.setState({
            [e.target.name]: e.target.value
        });
    }

    onSubmit(event){
        var newPostKey = firebase.database().ref().child('barters').push().key;
        const {isSignedIn, title, descr, photoUrl, userID} = this.state;
        firebase.database().ref('barters/' + newPostKey).set({
            dateTime: firebase.database.ServerValue.TIMESTAMP,
            descr,
            photoUrl,
            title,
            userID,
      });
  
      this.setState({dateTime: '', descr: '', photoUrl: '', title: ''});
    }

    addPicture(event){
        let reader = new FileReader();
        let file = event.target.files[0];
        reader.onloadend = ()=>{
            this.setState({
            photoUrl: reader.result
            });
        };
        reader.readAsDataURL(file);
    }

    render () {
        return (
            
                <div class="modal fade" id="addItem" tabindex="-1" role="dialog" aria-labelledby="addItemLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <p class="heading" id="addItemLabel">
                                    <strong>Add Item</strong>
                                </p>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true" class="white-text">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group row"> 
                                    <div class="col-sm-10">
                                        <input type="text" class="form-control" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
                                    </div>
                                </div> 
                                <br />
                                <div class="form-group row">
                                    <div class="col-sm-10">
                                        <input type="text" class="form-control" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
                                    </div>
                               </div>
                                <label class="upload-group">
                                    Upload Image
                                    <br/>
                                     
                                    <span class="btn btn-default btn-file">
                                        <input type="file" class="upload-group" id="file" onChange={(event) => {
                                            this.addPicture(event);
                                  
                                    }}/>
                                      </span>
                                    </label>
                                <PreviewPicture photoUrl={this.state.photoUrl}/>
                            </div>
                            <div class="modal-footer">
                                
                                {/* <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button> */}
                                <button type="btn btn-info" onClick={this.onSubmit} type="reset">Add Item to Barter</button>
                            </div>
                        </div>
                    </div>
                </div>

        //             {/* <input type="text" name="title" placeholder="What item do you want to trade?" onChange={this.handleChange} value={this.state.item} />
        //             <input type="text" name="descr" placeholder="Describe your item" onChange={this.handleChange} value={this.state.descr} />
        //             <label class="upload-group">
        //             Upload Image
        //             <input type="file" class="upload-group" id="file" onChange={(event) => {
        //                 this.addPicture(event);
        //             }}/>
        //             </label>
        //             <PreviewPicture photoUrl={this.state.photoUrl}/>
        //             <button type="btn btn-priamry" onClick={this.onSubmit} type="reset">Add Item to Barter</button>
        //         </form>
        //     </section>
        // ) */}

        )
    }
}

export default Item;
