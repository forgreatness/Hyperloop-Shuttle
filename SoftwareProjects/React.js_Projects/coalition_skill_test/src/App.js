/** @jsx jsx */
import React, { useState } from 'react';
import { jsx, css } from '@emotion/core';

import logo from './logo.svg';
import './App.css';

import image1 from './images/image1.png';
import image2 from './images/image2.png';
import image3 from './images/image3.png';
import icon from './images/icon.png';

function App() {
  const [isNavVisible, setNavVisibility] = useState(false);

  const styles = css`
  .nav-icon {
    display: none;
    padding: 10px 10px;
    width: 35px;
    cursor: pointer;
  }

  .nav-icon div {
    height: 5px;
    background-color: black;
    margin: 6px 0;
  }

  @media (max-width: 768px) {
    .nav-icon {
      display: block;
    }

    ul {
      visibility: ${isNavVisible ? "visible" : "hidden"};
      display: block;
      list-style: none;
      padding-left: 0;
      margin: 0;
      position: fixed;
      width: 200px;
      height: 100%;
      background-color: grey;
    }
    
    ul li {
      float: none;
    }

    ul li.float-right {
      float: none;
    }
  }`;

  const menuIcon = (<div className="nav-icon" onClick={() => setNavVisibility(prevVisibility => !prevVisibility)}>
    <div className="bar1"></div>
    <div className="bar2"></div>
    <div className="bar3"></div>
  </div>);

  return (
    <div className="App">
      <nav css={styles}>
        <ul>
          {menuIcon}
          <li className="float-left"><img src={icon} alt="Avatar" className="avatar" /></li>
          <li><a href="#">01. History</a></li>
          <li><a href="#">02. Team</a></li>
        </ul>
        {menuIcon}
      </nav>
      <img src={image1} alt="Los Angeles Mountains" />
      <img src={image2} alt="Reflection of mountains ranges on a water body" />
      <img src={image3} alt="A schedule of visits" />
    </div>
  );
}

export default App;
