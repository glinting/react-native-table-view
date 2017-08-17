
#import "RNTableViewCellView.h"
#import "RNTableView.h"
#import "UIView+Layout.h"

@implementation RNTableViewCellView

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    self.top = self.adjustTop;
    self.left = self.adjustLeft;
    [self.tableView reloadDataAsync];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.top = self.adjustTop;
    self.left = self.adjustLeft;
    [self.tableView reloadDataAsync];
}

@end
