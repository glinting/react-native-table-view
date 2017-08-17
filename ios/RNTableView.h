
#if __has_include("RCTViewManager.h")
#import "RCTComponent.h"
#else
#import <React/RCTComponent.h>
#endif
#import <UIKit/UITableView.h>

@interface RNTableView : UITableView

@property (nonatomic, strong) id itemRowHeight;
@property (nonatomic, strong) id itemSectionHeaderHeight;
@property (nonatomic, strong) NSArray *itemCount;
@property (nonatomic, strong) NSNumber *headerViewHeight;
@property (nonatomic, assign) float footerViewHeight;

@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) RCTBubblingEventBlock onSelect;

- (void)cellDidUpdate:(NSIndexPath *)indexPath;
- (void)reloadDataAsync;

@end
