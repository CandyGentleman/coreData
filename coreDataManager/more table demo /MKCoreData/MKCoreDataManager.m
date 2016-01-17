//
//  MKCoreDataManager.m
//  MKCoreData
//
//  Created by liulujie on 16/1/14.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import "MKCoreDataManager.h"


// 全局单例对象
static id instance;

//定义成员变量
static NSString *const modelName = @"Model";
static NSString *const dbName = @"sqlData.db";

@interface MKCoreDataManager()

// 定义后后台上下文
@property (nonatomic) NSManagedObjectContext *backgroundMoc;

@end

@implementation MKCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;

// 单例对象
+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

// 重写init方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self managedObjectContext];
    }
    return self;
}


#pragma mark - Core Data 设置
-(NSManagedObjectContext *)managedObjectContext{
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // 1. 创建模型的 URL，momd是在 bundle 中编译后的二进制包的扩展名
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    
    // 使用 URL 创建管理对象模型
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // 2. 创建 数据库 -> 传入对象模型，知道创建什么样的数据表
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    // 获得文档目录的 URL
    NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    // 建立数据库的完整 URL
    NSURL *storeURL = [docURL URLByAppendingPathComponent:dbName];
    NSLog(@"%@",storeURL);
    
    // 创建数据库 - 传入指定的数据库 URL，创建数据库
    // 如果成功，返回存储对象，如果失败，返回 nil
    if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil] == nil) {
        NSLog(@"创建数据库失败！返回空的上下文对象！");
        return nil;
    }
     //NSPrivateQueueConcurrencyType = 0x01,私有队列 -> 自定义队列，使用后台线程做数据操作
   //NSMainQueueConcurrencyType = 0x02  主队列 -> 主线程进行数据操作
    // 初始化后台上文
    _backgroundMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundMoc setPersistentStoreCoordinator:psc];
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 设置子上下的父类上下文_managedObjectContext
    [_managedObjectContext setParentContext:_backgroundMoc];
    return _managedObjectContext;
}

// 保存上下文数据
- (BOOL)saveContext{
    
    // 判断上下文是否为 nil
    if (self.managedObjectContext == nil) {
        NSLog(@"上下文为nil，无法进行数据操作");
        return NO;
    }
    NSError *error = nil;
    if (self.managedObjectContext.hasChanges && ![self.managedObjectContext save:&error]) {
        NSLog(@"没有需要保存的数据");
        return NO;
    }
    [self.backgroundMoc save:NULL];
    return YES;
}


@end
