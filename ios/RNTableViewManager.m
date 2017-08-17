
#import "RNTableViewManager.h"
#if __has_include("RCTBridge.h")
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "UIView+React.h"
#else
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>
#endif
#import "RNTableView.h"

@implementation RNTableViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RNTableView *tableView = [[RNTableView alloc] init];
    return tableView;
}

RCT_EXPORT_VIEW_PROPERTY(headerViewHeight, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(footerViewHeight, float)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(itemCount, NSArray *, RNTableView)
{
    if (!json) {
        return;
    }
    view.itemCount = json;
    [view reloadData];
}

RCT_CUSTOM_VIEW_PROPERTY(itemRowHeight, NSString *, RNTableView)
{
    if (!json) {
        return;
    }
    NSString *itemRowHeight = [RCTConvert NSString:json];
    view.itemRowHeight = [NSJSONSerialization JSONObjectWithData:[itemRowHeight dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (!view.itemRowHeight) {
        view.itemRowHeight = itemRowHeight;
    }
    [view reloadData];
}

RCT_CUSTOM_VIEW_PROPERTY(itemSectionHeaderHeight, NSString *, RNTableView)
{
    if (!json) {
        return;
    }
    NSString *itemSectionHeaderHeight = [RCTConvert NSString:json];
    view.itemSectionHeaderHeight = [NSJSONSerialization JSONObjectWithData:[itemSectionHeaderHeight dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (!view.itemSectionHeaderHeight) {
        view.itemSectionHeaderHeight = itemSectionHeaderHeight;
    }
    [view reloadData];
}

RCT_CUSTOM_VIEW_PROPERTY(reloadData, NSNumber *, RNTableView)
{
    [view reloadData];
}

RCT_CUSTOM_VIEW_PROPERTY(cellDidUpdate, NSString *, RNTableView)
{
    if (!json) {
        return;
    }
    NSArray *array = [json componentsSeparatedByString:@"-"];
    if (array.count == 2) {
        [view cellDidUpdate:[NSIndexPath indexPathForRow:[array[1] integerValue] inSection:[array[0] integerValue]]];
    }
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
