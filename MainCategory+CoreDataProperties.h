//
//  MainCategory+CoreDataProperties.h
//  
//
//  Created by JCB on 2/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "MainCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MainCategory (CoreDataProperties)

+ (NSFetchRequest<MainCategory *> *)fetchRequest;

@property (nonatomic) int32_t category_id;
@property (nullable, nonatomic, copy) NSDate *created_at;
@property (nonatomic) int32_t is_about;
@property (nonatomic) int32_t lft;
@property (nonatomic) int32_t parent_id;
@property (nonatomic) int32_t rgt;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *updated_at;
@property (nullable, nonatomic, retain) Article *article;
@property (nullable, nonatomic, retain) NSOrderedSet<MainCategory *> *sub_categories;
@property (nullable, nonatomic, retain) MainCategory *category;

@end

@interface MainCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(MainCategory *)value inSub_categoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSub_categoriesAtIndex:(NSUInteger)idx;
- (void)insertSub_categories:(NSArray<MainCategory *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSub_categoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSub_categoriesAtIndex:(NSUInteger)idx withObject:(MainCategory *)value;
- (void)replaceSub_categoriesAtIndexes:(NSIndexSet *)indexes withSub_categories:(NSArray<MainCategory *> *)values;
- (void)addSub_categoriesObject:(MainCategory *)value;
- (void)removeSub_categoriesObject:(MainCategory *)value;
- (void)addSub_categories:(NSOrderedSet<MainCategory *> *)values;
- (void)removeSub_categories:(NSOrderedSet<MainCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
