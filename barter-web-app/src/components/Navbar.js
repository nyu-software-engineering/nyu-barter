import React from 'react';
import { NavLink } from "react-router-dom"

const STATUS = {
  HOVERED: 'hovered',
  NORMAL: 'normal',
};


const Navbar = () => {
<<<<<<< HEAD
  constructor(props); 
     //super(props); 

    this._onMouseEnter = this._onMouseEnter.bind(this);
    this._onMouseLeave = this._onMouseLeave.bind(this);

    this.state = {
      class: STATUS.NORMAL,
    };

  
  

  _onMouseEnter() {
    this.setState({class: STATUS.HOVERED});
  } 

  _onMouseLeave() {
    this.setState({class: STATUS.NORMAL});
  } 

  render() {
    return (
      <nav> 
      <div> 
      <ul> 
        <li><a
        className={this.state.class}
        href={this.props.page || '/'}
        onMouseEnter = {this._onMouseEnter}
        onMouseLeave = {this._onMouseLeave}
      >
          {this.props.children}
       
        </a></li> 
        
        <li><a href="/interests">Interests</a></li>
        <li><a href="/inventory">Inventory</a></li>
      </ul> 
      </div> 
      </nav> 

    );
  }
=======
  return(
    <nav>
      <div>
        <ul>
          <li><NavLink to="/">Home</NavLink></li>
          <li><NavLink to="/interests">Interests</NavLink></li>
          <li><NavLink to="/inventory">Inventory</NavLink></li>
        </ul>
      </div>
    </nav>
    )
>>>>>>> 96561d17125398856c7fa0a68b19cec0328dcf0d
}


export default Navbar;

