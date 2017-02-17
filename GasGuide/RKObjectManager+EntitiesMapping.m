//
//  RKObjectManager+EntitiesMapping.m
//  GoldenSpear
//
//  Created by Jose Antonio Sanchez Martinez on 08/04/15.
//  Copyright (c) 2015 GoldenSpear. All rights reserved.
//

#import "RKObjectManager+EntitiesMapping.h"

@implementation RKObjectManager (EntitiesMapping)

- (void)defineMappings
{
    //// --------------------------------------------------////
    //// ---------------- ENTITIES MAPPING ----------------////
    //// --------------------------------------------------////
    
    RKEntityMapping *categoryMapping = [RKEntityMapping mappingForEntityForName:@"MainCategory" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

    
    categoryMapping.identificationAttributes = @[@"category_id"];
    [categoryMapping addAttributeMappingsFromDictionary:@{
                                                          @"id" : @"category_id",
                                                          @"title" : @"title",
                                                          @"parent_id" : @"parent_id",
                                                          @"_lft" : @"lft",
                                                          @"_rgt" : @"rgt",
                                                          @"is_about" : @"is_about",
                                                          @"created_at" : @"created_at",
                                                          @"updated_at" : @"updated_at"
                                                          }];
    
    RKEntityMapping *articleMapping = [RKEntityMapping mappingForEntityForName:@"Article" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    
    articleMapping.identificationAttributes = @[@"article_id"];
    [articleMapping addAttributeMappingsFromDictionary:@{
                                                         @"id" : @"article_id",
                                                         @"category_id" : @"category_id",
                                                         @"title" : @"title",
                                                         @"content" : @"content",
                                                         @"created_at" : @"created_at",
                                                         @"updated_at" : @"updated_at"
                                                         }];
    
    
    [categoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"articles" toKeyPath:@"article" withMapping:articleMapping]];
    
    [categoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children" toKeyPath:@"sub_categories" withMapping:categoryMapping]];
    
    RKResponseDescriptor *categoryDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:@"/gasguide/admin/public/api/get_data_tree"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self addResponseDescriptor:categoryDescriptor];
}

@end
