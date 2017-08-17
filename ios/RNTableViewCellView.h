
#import <UIKit/UIKit.h>
#if __has_include("RCTView.h")
#import "RCTView.h"
#else
#import <React/RCTView.h>
#endif

@class RNTableView;

@interface RNTableViewCellView : RCTView

@property (nonatomic, assign) CGFloat adjustTop;
@property (nonatomic, assign) CGFloat adjustLeft;
@property (nonatomic, weak) RNTableView *tableView;

@end
