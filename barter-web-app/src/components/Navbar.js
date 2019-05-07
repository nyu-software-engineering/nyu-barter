import React from 'react';
import { NavLink } from "react-router-dom";
import Link from './Link';

const STATUS = {
  HOVERED: 'hovered',
  NORMAL: 'normal',
};

class Navbar extends React.Component {

  constructor(props) {
    super(props);
    this._onMouseEnter = this._onMouseEnter.bind(this);
    this._onMouseLeave = this._onMouseLeave.bind(this);

    this.state = {
      class: STATUS.NORMAL,
    };
  }

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
        <li>
          <Link page="/"
                onMouseEnter ={this._onMouseEnter}
                onMouseLeave = {this._onMouseLeave}>
                Home
          </Link>
        </li>


        <li><a href="/interests">Interests</a></li>
        <li><a href="/inventory">Inventory</a></li>
      </ul>
      </div>
      </nav>

    );
  }

}


export default Navbar;
