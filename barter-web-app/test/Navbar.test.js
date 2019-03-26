import React from 'react';
import ReactDOM from 'react-dom';
import App from "../src/App";
import Navbar from "../src/components/Navbar";
import renderer from 'react-test-renderer';

// const testFirebase = require('firebase-functions-test')({
//   databaseURL: 'https://https://barterapp-ef89b.firebaseio.com',
//   storageBucket: 'BarterApp.appspot.com',
//   projectId: 'BarterApp',
// }, 'path/to/serviceAccountKey.json');

const STATUS = {
  HOVERED: 'hovered',
  NORMAL: 'normal',
};


test('Link changes the class when hovered', () => {
  const component = renderer.create(
    <Navbar></Navbar>
  );
  let tree = component.toJSON();
  //console.log(tree);
  expect(tree).toMatchSnapshot();

  // manually trigger the callback
  tree.props.onMouseEnter();
  // re-rendering
  tree = component.toJSON();
  expect(tree).toMatchSnapshot();

  // manually trigger the callback
  tree.props.onMouseLeave();
  // re-rendering
  tree = component.toJSON();
  expect(tree).toMatchSnapshot();
});