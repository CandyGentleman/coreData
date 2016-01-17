//
//  Title+CoreDataProperties.h
//  MKCoreData
//
//  Created by liulujie on 16/1/15.
//  Copyright © 2016年 liulujie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Title.h"

NS_ASSUME_NONNULL_BEGIN

@interface Title (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tilteName;
@property (nullable, nonatomic, retain) NSSet<Person *> *persons;

@end

@interface Title (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet<Person *> *)values;
- (void)removePersons:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
