import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

import Navbar from "./components/Navbar";
import Link from '../Link.react';
import renderer from 'react-test-renderer';

const testFirebase = require('firebase-functions-test')({
  databaseURL: 'https://https://barterapp-ef89b.firebaseio.com',
  storageBucket: 'BarterApp.appspot.com',
  projectId: 'BarterApp',
}, 'path/to/serviceAccountKey.json');


it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
  ReactDOM.unmountComponentAtNode(div);
});

test('Link changes the class when hovered', () => {
  const component = renderer.create(
    <Link page="/"></Link>,
  );
  let tree = component.toJSON();
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