
#import "RNTableView.h"
#if __has_include("RCTBridge+Private.h")
#import "RCTBridge+Private.h"
#import "UIView+React.h"
#else
#import <React/RCTBridge+Private.h>
#import <React/UIView+React.h>
#endif
#import "RNTableViewCellView.h"
#import "UIView+Layout.h"

const NSTimeInterval eventTimeInterval = 1.0/60;

@interface RNTableViewCell : UITableViewCell

@property (nonatomic, weak) UIView *itemView;

@end

@implementation RNTableViewCell

-(void)setItemView:(UIView *)itemView {
    [_itemView removeFromSuperview];
    _itemView = itemView;
    [self.contentView addSubview:itemView];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.itemView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end

@interface RNTableView() <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *unusedRowItemViews;
@property (nonatomic, strong) NSMapTable *allRowItemViews;
@property (nonatomic, strong) NSMutableDictionary *sectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *sendEvents;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL inReload;
@property (nonatomic, strong) NSMutableDictionary *needsUpdateCells;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation RNTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.unusedRowItemViews = [NSMutableArray array];
        self.allRowItemViews = [NSMapTable strongToWeakObjectsMapTable];
        self.sectionHeaderViews = [NSMutableDictionary dictionary];
        self.needsUpdateCells = [NSMutableDictionary dictionary];
        [self cleanLineWhenNotFullScreen];
    }
    return self;
}

- (void)cleanLineWhenNotFullScreen
{
    if (!self.tableFooterView) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = [UIColor clearColor];
        self.tableFooterView = v;
    }
}

- (void)cellDidUpdate:(NSIndexPath *)indexPath
{
    RNTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[RNTableViewCell class]] && cell.itemView) {
        
    }
}

#pragma mark - react native

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
    [super insertReactSubview:subview atIndex:atIndex];
    
    if ([subview isKindOfClass:[RNTableViewCellView class]]) {
        ((RNTableViewCellView *)subview).tableView = self;
    }

    NSString *testID = [subview accessibilityIdentifier];
    if ([testID hasPrefix:@"row-"]) {
        NSString *tag = [testID stringByReplacingOccurrencesOfString:@"row-" withString:@""];
        tag = [tag componentsSeparatedByString:@"-"][0];
        subview.tag = [tag integerValue];
        [self.unusedRowItemViews addObject:subview];
        [self.allRowItemViews setObject:subview forKey:tag];
    } else if ([testID hasPrefix:@"sectionHeader-"]) {
        NSString *tag = [testID stringByReplacingOccurrencesOfString:@"sectionHeader-" withString:@""];
        subview.tag = [tag integerValue];
        [self.sectionHeaderViews setObject:subview forKey:tag];
    } else if ([testID hasPrefix:@"footerView"]) {
        self.footerView = subview;
    } else if ([testID hasPrefix:@"headerView"]) {
        self.headerView = subview;
    }else {
        NSAssert(false, @"not support");
    }
}

- (void)didUpdateReactSubviews
{
    if (self.headerView) {
        self.headerView.height = [self.headerViewHeight floatValue];
        self.tableHeaderView = self.headerView;
    }
    if (self.footerView) {
        self.footerView.height = self.footerViewHeight;
        self.tableFooterView = self.footerView;
    }
    [self reloadData];
}

- (UIView*)unusedItemView: (NSUInteger)index {
    UIView* view = [self.unusedRowItemViews firstObject];
    if (view != nil) {
        [self.unusedRowItemViews removeObjectAtIndex:0];
    }
    NSAssert(view != nil, @"list view item count not enough");
    return view;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    if (![self shouldLoadData]) {
        return 0;
    }
    return [self.itemCount count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.itemSectionHeaderHeight isKindOfClass:[NSDictionary class]]) {
        return [[self.itemSectionHeaderHeight objectForKey:[NSString stringWithFormat:@"%@", @(section)]] floatValue];
    } else {
        return [self.itemSectionHeaderHeight floatValue];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeaderViews objectForKey:[NSString stringWithFormat:@"%@", @(section)]];
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (![self shouldLoadData]) {
        return 0;
    }
    return [self.itemCount[section] integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self shouldLoadData]) {
        return 0;
    }
    if ([self.itemRowHeight isKindOfClass:[NSArray class]]) {
        CGFloat height = [[[self.itemRowHeight objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] floatValue];
        return height;
    } else {
        return [self.itemRowHeight floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self shouldLoadData]) {
        static NSString *cellIdentifier = @"RNTempCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        return cell;
    }
    static NSString *cellIdentifier = @"RNTableViewCell";
    
    RNTableViewCell *cell = (RNTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RNTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.itemView = [self unusedItemView: indexPath.row];
        [self.needsUpdateCells setObject:indexPath forKey:@(cell.itemView.tag)];
    } else {
        NSString *tag = [NSString stringWithFormat:@"%@", @(cell.itemView.tag)];
        UIView *itemView = [self.allRowItemViews objectForKey:tag];
        if (itemView && itemView != cell.itemView) {
            cell.itemView = itemView;
            [self.needsUpdateCells setObject:indexPath forKey:@(cell.itemView.tag)];
        } else {
            NSIndexPath *index = [self.needsUpdateCells objectForKey:@(cell.itemView.tag)];
            if (!index || [index compare:indexPath] != NSOrderedSame) {
                [self.needsUpdateCells setObject:indexPath forKey:@(cell.itemView.tag)];
            }
        }
    }
    
    NSDictionary *event = @{
                            @"childIndex": @(cell.itemView.tag),
                            @"rowID": @(indexPath.row),
                            @"sectionID": @(indexPath.section),
                            };
    
    [self sendEvents:event delay:eventTimeInterval];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = nil;
    return cell;
}

- (void)sendEvents:(NSDictionary *)event delay:(NSTimeInterval)delay
{
    dispatch_block_t block = ^{
        NSTimeInterval offset = [[NSDate date] timeIntervalSince1970] - self.timeInterval;
        if (offset > eventTimeInterval) {
            self.onChange(self.sendEvents);
            self.sendEvents = nil;
        } else {
            [self sendEvents:nil delay:eventTimeInterval-offset];
        }
    };
    if (!event) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        return;
    }
    self.timeInterval = [[NSDate date] timeIntervalSince1970];
    if (!self.sendEvents) {
        self.sendEvents = [NSMutableDictionary dictionary];
        [self.sendEvents setObject:event forKey:[NSString stringWithFormat:@"%@", [event objectForKey:@"childIndex"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    } else {
        [self.sendEvents setObject:event forKey:[NSString stringWithFormat:@"%@", [event objectForKey:@"childIndex"]]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *event = @{
                            @"rowID": @(indexPath.row),
                            @"sectionID": @(indexPath.section),
                            };
    self.onSelect(event);
}

- (BOOL)shouldLoadData
{
    if (!self.itemCount || !self.itemRowHeight) {
        return NO;
    }
    if ([self.itemRowHeight isKindOfClass:[NSArray class]]) {
        if (self.itemCount.count != [self.itemRowHeight count]) {
            return NO;
        }
        for (int i = 0 ; i < self.itemCount.count; i++) {
            if ([self.itemCount[i] integerValue] != [[self.itemRowHeight objectAtIndex:i] count]) {
                return NO;
            }
        }
    }
    int count = 0;
    for (int i = 0 ; i < self.itemCount.count; i++) {
        count += [self.itemCount[i] integerValue];
    }
    if (count && self.allRowItemViews.count == 0) {
        return NO;
    }
    return YES;
}

- (void)reloadDataAsync
{
    if (self.inReload) {
        return;
    }
    if ([self shouldLoadData]) {
        self.inReload = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            self.inReload = NO;
        });
    }
}

- (void)reloadData
{
    if ([self shouldLoadData]) {
        [super reloadData];
    }
}

- (void)setHeaderViewHeight:(NSNumber *)headerViewHeight
{
    _headerViewHeight = headerViewHeight;
    if (self.headerView) {
        self.headerView.height = [self.headerViewHeight floatValue];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, [self.headerViewHeight floatValue])];
        self.tableHeaderView = self.headerView;
    }
}

@end
