//
//  DisclosureViewController.h
//  GasGuide
//
//  Created by JCB on 2/17/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCategory+CoreDataClass.h"

@interface DisclosureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (nonatomic) Article *article;

@end
