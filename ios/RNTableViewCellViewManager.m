
#import "RNTableViewCellViewManager.h"
#import "RNTableViewCellView.h"

@implementation RNTableViewCellViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RNTableViewCellView *view = [RNTableViewCellView new];
    return view;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
