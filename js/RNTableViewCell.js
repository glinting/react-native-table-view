
import React, { Component } from 'react';
import { View } from 'react-native';
import RNTableViewCellView from './RNTableViewCellView';

export default class RNTableViewCell extends Component {

    static propTypes = {
        item: React.PropTypes.object,
        renderRow: React.PropTypes.func,
    };

    shouldComponentUpdate(nextProps) {
        if (nextProps.item.sectionID == -1 || nextProps.item.rowID == -1) {
            return false;
        }
        return nextProps.item.sectionID !== this.props.item.sectionID || nextProps.item.rowID !== this.props.item.rowID;
    }

    componentDidMount() {
        if (this.props.didUpdate) {
            this.props.didUpdate({ cellDidUpdate: `${this.props.item.sectionID}-${this.props.item.rowID}` });
        }
    }

    componentDidUpdate() {
        if (this.props.didUpdate) {
            this.props.didUpdate({ cellDidUpdate: `${this.props.item.sectionID}-${this.props.item.rowID}` });
        }
    }

    render() {
        return (<RNTableViewCellView testID={this.props.testID}>
            {(this.props.item.sectionID == -1 || this.props.item.rowID == -1) ?
              <View /> : this.props.renderRow(this.props.item.sectionID, this.props.item.rowID)}
        </RNTableViewCellView>);
    }
}