//
//  MainViewController.m
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import "MainViewController.h"
#import <RestKit/RestKit.h>
#import "MainCategory+CoreDataClass.h"
#import "SWRevealViewController.h"
#import "LeftMenuViewController.h"
#import "SubCategoryViewController.h"
#import "DisclosureViewController.h"
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD.h>

@interface MainViewController () {
    NSMutableArray *categoryArray;
    MainCategory *menuCategory;
    SWRevealViewController *revealController;
    
    NSFetchedResultsController *categoryFetchedController;
    NSFetchRequest *categoryFetchRequest;

    NSMutableArray *autoArray;
}

@end

@implementation MainViewController

@synthesize tableView;
@synthesize topSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    topSearchBar = [[UISearchBar alloc] init];
    topSearchBar.placeholder = @"Search";
    topSearchBar.delegate = self;
    self.navigationItem.titleView = topSearchBar;
    
    revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu_black_24dp"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    categoryArray = [[NSMutableArray alloc] init];
    autoArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = (NSDate*)[defaults objectForKey:@"lastUpdate"];
    
    if (lastUpdate == nil) {
        [self fetchDatafromServer];
    }
    else {
        NSDate *today = [NSDate date];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:lastUpdate
                                                              toDate:today
                                                             options:0];
        
        if (components.day > 7) {
            [self fetchDatafromServer];
            
            return;
        }
        else {
            NSCalendar* cal = [NSCalendar currentCalendar];
            NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
            
            if (comp.weekday == 1) {
                [self fetchDatafromServer];
                
                return;
            }
        }
        
        
        [self fetchCategories];
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self setNavigationBarItem];
//}



// Rest answer arrived. Check if it succeedded or not
- (void)processAnswerToRestConnection:(NSArray *)mappingResult lookingForClasses:(NSArray *)dataClasses andIfErrorMessage:(NSArray *)errorMessage
{
    if (!(mappingResult == nil)) {
        
        categoryArray = [NSMutableArray new];
        
        for (MainCategory *category in mappingResult) {
            if ([category isKindOfClass:[MainCategory class]]) {
                if (category.is_about == 1) {
                    menuCategory = category;
                }
                else {

                    [categoryArray addObject:category];
                    [autoArray addObject:category];
                }
            }
        }
        
        UINavigationController *leftNavi = (UINavigationController*)revealController.rearViewController;
        ((LeftMenuViewController*)leftNavi.viewControllers[0]).delegate = self;
        ((LeftMenuViewController*)leftNavi.viewControllers[0]).menuCategory = menuCategory;
        [((LeftMenuViewController*)leftNavi.viewControllers[0]) reloadMenu];
        [tableView reloadData];
    }
    
    NSDate *today = [NSDate date];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:today forKey:@"lastUpdate"];
    [userDefaults synchronize];
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
    
    static NSString *cell_ID= @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID forIndexPath:indexPath];
    
    // Configure the cell
    MainCategory *category = [autoArray objectAtIndex:indexPath.row];
    
    for (MainCategory *subcategory in category.sub_categories) {
        if ([subcategory isKindOfClass:[MainCategory class]]) {
            NSLog(@"%@", subcategory.title);
            
            for (MainCategory *temp in subcategory.sub_categories) {
                if ([temp isKindOfClass:[MainCategory class]]) {
                    NSLog(@"%@", temp.title);
                }
            }
        }
    }
    
    cell.textLabel.text = category.title;
    cell.textLabel.font = [UIFont systemFontOfSize:23.0];
    
    if (category.sub_categories == nil && category.article == nil) {
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
    
    [topSearchBar resignFirstResponder];
    [self.view endEditing:YES];
    
    SubCategoryViewController *subCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoryViewController"];
    
    DisclosureViewController *disclosureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureViewController"];
    
    MainCategory *category = [autoArray objectAtIndex:indexPath.row];
    if ([category.sub_categories count] > 0) {
        subCategoryVC.parentCategory = category;
        [self.navigationController pushViewController:subCategoryVC animated:YES];
    }
    else if (category.article != nil) {
        disclosureVC.article = category.article;
        [self.navigationController pushViewController:disclosureVC animated:YES];
    }
}

// Initialize a specific Fetched Results Controller to fetch the current user follows in order to properly show the heart button
- (BOOL)initFollowsFetchedResultsControllerWithEntity:(NSString *)entityName andPredicate:(NSString *)predicate withString:(NSString *)stringForPredicate sortingWithKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    BOOL bReturn = FALSE;
    
    if(categoryFetchedController == nil)
    {
        NSManagedObjectContext *currentContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
        
        if (categoryFetchRequest == nil)
        {
            if(!(stringForPredicate == nil))
            {
                categoryFetchRequest = [[NSFetchRequest alloc] init];
                
                // Entity to look for
                
                NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:currentContext];
                
                [categoryFetchRequest setEntity:entity];
                
                // Filter results
                
                //[categoryFetchRequest setPredicate:[NSPredicate predicateWithFormat:predicate, @"3"]];
                
                // Sort results
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
                
                [categoryFetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                
                [categoryFetchRequest setFetchBatchSize:20];
            }
        }
        
        if(categoryFetchRequest)
        {
            // Initialize Fetched Results Controller
            
            //NSSortDescriptor *tmpSortDescriptor = (NSSortDescriptor *)[_followsFetchRequest sortDescriptors].firstObject;
            
            NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoryFetchRequest managedObjectContext:currentContext sectionNameKeyPath:nil cacheName:nil];
            
            categoryFetchedController = fetchedResultsController;
            
            categoryFetchedController.delegate = self;
        }
        
        if(categoryFetchedController)
        {
            // Perform fetch
            
            NSError *error = nil;
            
            if (![categoryFetchedController performFetch:&error])
            {
                // TODO: Update to handle the error appropriately. Now, we just assume that there were not results
                
                NSLog(@"Couldn't fetched. Unresolved error: %@, %@", error, [error userInfo]);
                
                return FALSE;
            }
            
            bReturn = ([categoryFetchedController fetchedObjects].count > 0);
        }
    }
    
    return bReturn;
}

-(void) fetchCategories {
    categoryFetchedController = nil;
    categoryFetchRequest = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self initFollowsFetchedResultsControllerWithEntity:@"MainCategory" andPredicate:@"NOT (parent_id = %@)" withString:@"0" sortingWithKey:@"title" ascending:YES];
    
    if ([[categoryFetchedController fetchedObjects] count] > 0) {
        NSLog(@"%li", [[categoryFetchedController fetchedObjects] count]);
        
        for (MainCategory *category in [categoryFetchedController fetchedObjects]) {
            if ([category isKindOfClass:[MainCategory class]]) {
                if (category.parent_id == 0) {
                    if (category.is_about == 1) {
                        menuCategory = category;
                    }
                    else {
                        [categoryArray addObject:category];
                        [autoArray addObject:category];
                    }
                }
            }
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UINavigationController *leftNavi = (UINavigationController*)revealController.rearViewController;
    ((LeftMenuViewController*)leftNavi.viewControllers[0]).delegate = self;
    ((LeftMenuViewController*)leftNavi.viewControllers[0]).menuCategory = menuCategory;
    [((LeftMenuViewController*)leftNavi.viewControllers[0]) reloadMenu];
    
    [tableView reloadData];
}

-(void)fetchDatafromServer {
    NSString *requestPath = @"/gasguide/admin/public/api/get_data_tree";
    NSArray *failedAnswerErrorMessage;
    NSArray * dataClasses;
    
    dataClasses = [NSArray arrayWithObjects:[MainCategory class], nil];
    
    //Message to show if not succeed
    failedAnswerErrorMessage = [NSArray arrayWithObjects:NSLocalizedString(@"_ERROR_", nil), NSLocalizedString(@"_NO_CATEGORY_ERROR_MSG_", nil), NSLocalizedString(@"_OK_", nil), nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //articles have been saved in core data by now
         [self processAnswerToRestConnection:[mappingResult array] lookingForClasses:dataClasses andIfErrorMessage:failedAnswerErrorMessage];
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         RKLogError(@"Load failed with error: %@", error);
     }
     ];
}

#pragma mark - LeftMenu Delegate
- (void)updateData {
    [self.revealViewController revealToggleAnimated:YES];
    [self fetchDatafromServer];
}

- (void)sendFeedback {
    [self.revealViewController revealToggleAnimated:YES];
    
    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailTitle = @"Test Email";
        // Email Content
        NSString *messageBody = @"iOS programming is so fun!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void)onTapMenu:(Article *)article {
    DisclosureViewController *disclosureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureViewController"];
    
    disclosureVC.article = article;
    [self.navigationController pushViewController:disclosureVC animated:YES];
}

#pragma mark - MailComporse Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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

@end
