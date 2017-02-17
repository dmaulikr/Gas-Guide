//
//  SubCategoryViewController.h
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCategory+CoreDataClass.h"

@interface SubCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MainCategory *parentCategory;
@property (nonatomic) UISearchBar *topSearchBar;

@end
