//
//  LeftMenuViewController.m
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController () {
    NSMutableArray *menuArray;
}

@end

@implementation LeftMenuViewController

@synthesize tableView;
@synthesize menuCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadMenu {
    menuArray = [NSMutableArray new];
    
    for (MainCategory *subCategory in menuCategory.sub_categories) {
        if ([subCategory isKindOfClass:[MainCategory class]]) {
            [menuArray addObject:subCategory];
        }
    }
    
    self.title = menuCategory.title;
    [tableView reloadData];
}

#pragma mark - Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [menuArray count] + 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_ID= @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:23.0];
    
    if (indexPath.row == [menuArray count]) {
        cell.textLabel.text = @"Data Updates";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    if (indexPath.row > [menuArray count]) {
        cell.textLabel.text = @"Send Feedback";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    // Configure the cell
    MainCategory *category = [menuArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = category.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [menuArray count]) {
        MainCategory *category = [menuArray objectAtIndex:indexPath.row];
        [_delegate onTapMenu:category.article];
    }
    else if (indexPath.row == [menuArray count]) {
        [_delegate updateData];
    }
    else {
        [_delegate sendFeedback];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
