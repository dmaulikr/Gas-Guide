//
//  LeftMenuViewController.h
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCategory+CoreDataClass.h"

@protocol LeftMenuDelegate <NSObject>

- (void)updateData;
- (void)sendFeedback;
- (void)onTapMenu:(Article*)article;

@end

@interface LeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<LeftMenuDelegate> delegate;

@property (nonatomic) MainCategory *menuCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)reloadMenu;

@end
