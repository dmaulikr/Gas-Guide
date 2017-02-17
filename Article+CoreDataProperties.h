//
//  Article+CoreDataProperties.h
//  
//
//  Created by JCB on 2/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Article+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest;

@property (nonatomic) int32_t article_id;
@property (nonatomic) int32_t category_id;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *created_at;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *updated_at;

@end

NS_ASSUME_NONNULL_END
