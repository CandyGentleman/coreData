//
//  Person+CoreDataProperties.h
//  MKCoreData
//
//  Created by liulujie on 16/1/15.
//  Copyright © 2016年 liulujie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Title *title;

@end

NS_ASSUME_NONNULL_END
