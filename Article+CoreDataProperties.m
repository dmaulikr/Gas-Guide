//
//  Article+CoreDataProperties.m
//  
//
//  Created by JCB on 2/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Article+CoreDataProperties.h"

@implementation Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Article"];
}

@dynamic article_id;
@dynamic category_id;
@dynamic content;
@dynamic created_at;
@dynamic title;
@dynamic updated_at;

@end
