import React from 'react';
import PreviewPicture from './PreviewPicture';

export default function Card(props){
    const itemId = props.data;

    return (
        <div className = "col-3">
            <div className ="card" styles="width: 18rem;">
                <p className = "card-img top"><PreviewPicture photoUrl={itemId.photoUrl}/></p>
                <div className ="card-body">
                    <a href="#" class="item-title" data-toggle="modal" data-target="#displayDescr"><h5 className ="card-title">{itemId.title}</h5></a>
                </div>
            </div>
        </div> 
    )
}
