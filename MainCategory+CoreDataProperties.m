//
//  MainCategory+CoreDataProperties.m
//  
//
//  Created by JCB on 2/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "MainCategory+CoreDataProperties.h"

@implementation MainCategory (CoreDataProperties)

+ (NSFetchRequest<MainCategory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MainCategory"];
}

@dynamic category_id;
@dynamic created_at;
@dynamic is_about;
@dynamic lft;
@dynamic parent_id;
@dynamic rgt;
@dynamic title;
@dynamic updated_at;
@dynamic article;
@dynamic sub_categories;
@dynamic category;

@end
