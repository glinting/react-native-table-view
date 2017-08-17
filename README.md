
# react-native-table-view

## Getting started

`$ npm install react-native-table-view --save`

### Mostly automatic installation

`$ react-native link react-native-table-view`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-table-view` and add `RNTableView.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNTableView.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNTableViewPackage;` to the imports at the top of the file
  - Add `new RNTableViewPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-table-view'
  	project(':react-native-table-view').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-table-view/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-table-view')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNTableView.sln` in `node_modules/react-native-table-view/windows/RNTableView.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNTableView;` to the usings at the top of the file
  - Add `new RNTableViewPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNTableView from 'react-native-table-view';

// TODO: What to do with the module?
RNTableView;
```
  