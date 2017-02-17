//
//  SubCategoryViewController.m
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "DisclosureViewController.h"

@interface SubCategoryViewController () {
    
    NSMutableArray *categoryArray;
    NSMutableArray *autoArray;
}

@end

@implementation SubCategoryViewController
@synthesize tableView;
@synthesize parentCategory;
@synthesize topSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    topSearchBar = [[UISearchBar alloc] init];
    topSearchBar.placeholder = @"Search";
    topSearchBar.delegate = self;
    self.navigationItem.titleView = topSearchBar;
    
    categoryArray = [[NSMutableArray alloc] init];
    autoArray = [[NSMutableArray alloc] init];
    
    for (MainCategory *category in parentCategory.sub_categories) {
        if ([category isKindOfClass:[MainCategory class]]) {
            [categoryArray addObject:category];
            [autoArray addObject:category];
            NSLog(@"%@", category.title);
        }
    }
    
    [tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [topSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [autoArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_ID= @"SubCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID forIndexPath:indexPath];
    
    // Configure the cell
    MainCategory *category = [autoArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = category.title;
    cell.textLabel.font = [UIFont systemFontOfSize:23.0];
    NSLog(@"%li", [category.sub_categories count]);
    
    if ([category.sub_categories count] < 1 && category.article == nil) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubCategoryViewController *subCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoryViewController"];
    
    DisclosureViewController *disclosureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureViewController"];
    
    MainCategory *category = [autoArray objectAtIndex:indexPath.row];
    if ([category.sub_categories count] > 0) {
        subCategoryVC.parentCategory = category;
        [self.navigationController pushViewController:subCategoryVC animated:YES];
    }
    else if (category.article != nil) {
        disclosureVC.article = (Article*)category.article;
        [self.navigationController pushViewController:disclosureVC animated:YES];
    }
}

#pragma mark - Search Bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *substring = [NSString stringWithString:searchBar.text];
    [self searchAutocompleteEntriesWithSubstring:substring];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [autoArray removeAllObjects];
    autoArray = [NSMutableArray new];
    
    if ([substring isEqualToString:@""]) {
        autoArray = [categoryArray mutableCopy];
        [tableView reloadData];
        return;
    }
    
    for (MainCategory *category in categoryArray) {
        NSRange substringRangeLowerCase = [[category.title lowercaseString] rangeOfString:[substring lowercaseString]];
        
        if (substringRangeLowerCase.length != 0) {
            [autoArray addObject:category];
        }
    }
    
    [tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [topSearchBar resignFirstResponder];
    [self.view endEditing:YES];
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
