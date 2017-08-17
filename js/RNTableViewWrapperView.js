
import React, { Component } from 'react';
import { View } from 'react-native';
import RNTableViewCellView from './RNTableViewCellView';

export default class RNTableViewWrapperView extends Component {

    static propTypes = {
        renderView: React.PropTypes.func,
        arguments: React.PropTypes.array,
    };

    static defaultProps = {
        renderView: null,
        arguments: [],
    };

    render() {
        if (this.props.renderView) {
            return (<RNTableViewCellView testID={this.props.testID}>
                {this.props.renderView.apply(null, this.props.arguments)}
            </RNTableViewCellView>);
        }
        return <View testID={this.props.testID} />;
    }

}