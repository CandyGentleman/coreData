//
//  MKCoreDataManager.h
//  MKCoreData
//
//  Created by liulujie on 16/1/14.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface MKCoreDataManager : NSObject

// 定义一个只读上下文本属性
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// 提供一个单例的类方法
+(instancetype)shareManager;

// 保存上下文的方法
- (BOOL)saveContext;

@end
