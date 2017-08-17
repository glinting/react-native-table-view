
import React, { Component, PropTypes } from 'react';
import { requireNativeComponent, View, Text, Platform, Dimensions } from 'react-native';
import RNTableViewCell from './RNTableViewCell';
import RNTableViewWrapperView from './RNTableViewWrapperView';

const TableView = requireNativeComponent('RNTableView', null, {
    nativeOnly: {},
});

export default class RNTableView extends Component {

    static propTypes = {
        itemRowHeight: PropTypes.any,
        itemCount: PropTypes.array,
        renderRow: PropTypes.func,
        headerViewHeight: PropTypes.number,
        renderHeaderView: PropTypes.func,
        footerViewHeight: PropTypes.number,
        renderFooterView: PropTypes.func,
        itemSectionHeaderHeight: PropTypes.any,
        renderSectionHeader: PropTypes.func,
        onSelect: PropTypes.func,
    };

    static defaultProps = {
        headerViewHeight: 0,
        renderHeaderView: null,
        footerViewHeight: 0,
        renderFooterView: null,
        itemSectionHeaderHeight: 0,
        renderSectionHeader: null,
    };

    constructor(props) {
        super(props);

        this.state = {
            items: this._getItems(this.props.itemRowHeight, this.props.itemCount), // childIndex -> rowID
        };

    }

    componentWillReceiveProps(nextProps) {
        const forceUpdate = this.forceUpdate === true ? true : this._isForceUpdate(this.props.itemCount, nextProps.itemCount);
        this.forceUpdate = false;
        if (forceUpdate) {
            this.setState({ items: this._getItems(nextProps.itemRowHeight, nextProps.itemCount, true) });
            this.setNativeProps({ reloadData: 1 });
        } else {
            const items = this._getItems(nextProps.itemRowHeight, nextProps.itemCount);
            if (items.length > this.state.items.length) {
                for (let i = this.state.items.length; i < items.length; i++) {
                    this.state.items.push(items[i]);
                }
                this.setState({ items: this.state.items });
            }
        }
    }

    _isForceUpdate(itemCount, nextItemCount) {
        if (nextItemCount.length < itemCount.length) {
            return true;
        }
        for (let i = 0; i < itemCount.length - 1; i++) {
            if (itemCount[i] != nextItemCount[i]) {
                return true;
            }
        }
        if (nextItemCount[itemCount.length - 1] < itemCount[itemCount.length - 1]) {
            return true;
        }
        return false;
    }

    _getItems(height, count, force = false) {

        const items = [];
        let size = 20;
        for (let i = 0; i < size; i++) {
            let sectionID = -1;
            let rowID = -1;
            let currentRow = i;
            for (let j = 0; j < count.length; j++) {
                if (!count[j]) {
                    continue;
                }
                if (currentRow < count[j]) {
                    sectionID = j;
                    rowID = currentRow;
                    break;
                } else {
                    currentRow -= count[j];
                }
            }
            const item = {
                realSectionID: sectionID,
                realRowID: rowID,
            };
            if (force) {
                item.sectionID = -1;
                item.rowID = -1;
            } else {
                item.sectionID = sectionID;
                item.rowID = rowID;
            }
            items.push(item);
        }
        return items;
    }

    render() {
        const props = Object.assign({}, this.props);
        return (
          <TableView
            ref="_tableView"
            {...props}
            itemRowHeight={JSON.stringify(this.props.itemRowHeight)}
            itemSectionHeaderHeight={JSON.stringify(this.props.itemSectionHeaderHeight)}
            onSelect={(event) => {
                const { rowID, sectionID } = event.nativeEvent;
                if (this.props.onSelect) {
                    this.props.onSelect(sectionID, rowID);
                }
            }}
            onChange={(event) => {
                event = event.nativeEvent;
                delete event.target;
                const events = Object.values(event);
                for (let i = 0; i < events.length; i++) {
                    const { childIndex, rowID, sectionID } = events[i];
                    if (sectionID < this.props.itemCount.length && rowID < this.props.itemCount[sectionID]) {
                        this.state.items[childIndex] = Object.assign({}, this.state.items[childIndex], {
                            sectionID,
                            rowID,
                        });
                    }
                }
                this.setState({
                    items: this.state.items,
                });
            }} >
              {
                  this.props.renderHeaderView ? <RNTableViewWrapperView testID={'headerView'} renderView={this.props.renderHeaderView} /> : null
              }
              {
                  this.state.items.map((item, index) => (<RNTableViewCell
                    testID={Platform.OS == 'ios' || this.props.isConvertItemRow === true ? (`row-${index}`) : (`row-${index}-sectionID-${item.realSectionID}-rowID-${item.realRowID}`)}
                    key={`row-${index}`}
                    item={item}
                    renderRow={this.props.renderRow}
                    didUpdate={(props) => {
                        this.setNativeProps(props);
                    }}
                  />))
              }
              {
                  this.props.itemCount.map((item, index) => (<RNTableViewWrapperView
                    testID={`sectionHeader-${index}`}
                    key={`sectionHeader-${index}`}
                    arguments={[index]}
                    renderView={this.props.renderSectionHeader}
                  />))
              }
              {
                  this.props.renderFooterView ? <RNTableViewWrapperView
                    testID={'footerView'}
                    renderView={this.props.renderFooterView}
                  /> : null
              }
          </TableView>
        );
    }

    forceUpdateNexLoop() {
        this.forceUpdate = true;
    }

    changeItem(sectionID, rowID) {
        for (let i = 0; i < this.state.items.length; i++) {
            const item = this.state.items[i];
            if ((sectionID == -1 && rowID == -1) || (item.sectionID == sectionID && item.rowID == rowID)) {
                item.sectionID = -1;
                item.rowID = -1;
            }
        }
    }

    setNativeProps(props) {
        if (this.refs._tableView) {
            this.refs._tableView.setNativeProps(props);
        }
    }

}
