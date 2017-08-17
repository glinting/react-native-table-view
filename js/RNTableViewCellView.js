
import React, { Component } from 'react';
import { requireNativeComponent } from 'react-native';

const TableViewCellView = requireNativeComponent('RNTableViewCellView', null, {
    nativeOnly: {},
});

export default class RNTableViewCellView extends Component {

    render() {
        return (
          <TableViewCellView {...this.props} />
        );
    }

}
