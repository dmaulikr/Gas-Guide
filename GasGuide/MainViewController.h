//
//  MainViewController.h
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LeftMenuViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, LeftMenuDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UISearchBar *topSearchBar;

@end
