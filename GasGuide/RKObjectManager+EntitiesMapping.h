//
//  RKObjectManager+EntitiesMapping.h
//  GoldenSpear
//
//  Created by Jose Antonio Sanchez Martinez on 08/04/15.
//  Copyright (c) 2015 GoldenSpear. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "MainCategory+CoreDataClass.h"
#import "Article+CoreDataClass.h"
#import "Temp.h"

@interface RKObjectManager (EntitiesMapping)

- (void)defineMappings;

@end
