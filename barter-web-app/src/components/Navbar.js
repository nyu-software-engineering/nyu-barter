import React from 'react';
import { NavLink } from "react-router-dom"


const Navbar = () => {
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
}

export default Navbar
