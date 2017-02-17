//
//  DisclosureViewController.m
//  GasGuide
//
//  Created by JCB on 2/17/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import "DisclosureViewController.h"
#import "Article+CoreDataClass.h"

@interface DisclosureViewController ()

@end

@implementation DisclosureViewController
@synthesize txtView;
@synthesize article;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtView.text = article.content;
    self.title = article.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
