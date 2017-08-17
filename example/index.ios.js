
import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import RNTableView from 'react-native-table-view';

export default class AwesomeProject extends Component {
  render() {
    return (
      <RNTableView style = {{flex:1}}
                   itemRowHeight={130}
                   itemCount={[10,20]}
                   renderRow={(sectionId, rowId) => {
                     return <View><Text>{sectionId}-{rowId}</Text></View>
                   }}
                   onSelect={() => {

                   }}
                   itemSectionHeaderHeight={30}
                   renderSectionHeader={(sectionId) => {
                     return <View style = {{backgroundColor:'red'}}><Text>{sectionId}</Text></View>
                   }}
                   headerViewHeight={100}
                   renderHeaderView={() => {
                     return <View style = {{backgroundColor:'blue'}}><Text>header</Text></View>
                   }}
                   footerViewHeight={100}
                   renderFooterView={() => {
                     return <View style = {{backgroundColor:'green'}}><Text>footer</Text></View>
                   }}
      >
      </RNTableView>
    );
  }
}

AppRegistry.registerComponent('AwesomeProject', () => AwesomeProject);
