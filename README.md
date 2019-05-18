# NYU BARTER

## Project Description
NYU Barter is a mobile application that allows users to trade items they don't want in exchange for items posted by other users. Users will be allowed to post items to trade, pick items that they would be willing to trade for and start a chat if two users happen to be interested in each other's items.

## Project History
The project came about after observing college students on online marketplaces. Given their circumstances, most students buy and sell things such as books and furniture on a frequent basis. However, with this platform, they now have a direct channel to get rid of things they don't need in exchange for things that they want. For instance a student could use the platform to trade books they longer need for books they'll need in the following semester.

This project is currently being developed as part of NYU's Agile Software Development and DevOps course.

## Contributing
For instructions on contributing to this project, read the following [CONTRIBUTING.md](CONTRIBUTING.md) file

## Building and Testing | iOS App 
The iOS app uses [Cocoapods](https://cocoapods.org/) as an application level dependency manager. This can be installed by typing:

```
$ sudo gem install cocoapods
```

Once installed, pull the current code and locate the folder named "barterApp"
Cd into this directory and type the command

```
pod install
```

Now that all of the dependencies are installed, click on the file named: 

**barterApp.xcworkspace**

The product can be buit on a simulated device by clicking the play button in the top left corner.

## Building and Testing | Web App 

You can run app the on our [website](https://barter.cf/)

## Available Scripts

In the project directory bater-web-app you need our secret .env file to connect to our firebase database, next do npm install on terminal once you have the .env and installed modules you can run:

### `npm start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br>
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br>
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br>
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br>
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).



## Team Members
* Anandini Chawla
* Kevin Maldjian
* Santiago Rendon
* Sushanth Kambham
* William Cho
