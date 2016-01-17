### iOS coredata Stack 工具类封装技巧

#### 提问与回答
  苹果系统生成的模板中已经把 Core Data 的基础准备都放在 AppDelegate 中了，为什么还要自己封装？

 * 因为：基础准备代码比较繁琐，不容易记忆， 基础准备一经设置，也无法修改，为了提高灵活运用，还是自己封装一下比较好！
 
 
#### 基础知识了解
* Core Data 的核心对象都不是线程安全的，封装此框架之前，需要先了解一下的类：

  + NSManagedObjectContext 管理对象上下文
  + NSManagedObjectModel 管理对象模型
  + NSPersistentStoreCoordinator 持久化存储调度器

  - 思维导图，苹果官方给出的coreData的存储示意图如下：
  ![](http://d.picphotos.baidu.com/album/s%3D1100%3Bq%3D90/sign=b95df227758b4710ca2ff9cdf3fef88c/6a63f6246b600c3384b8d4ce1d4c510fd8f9a1f6.jpg)
  
#### 操作步骤
##### 新建 coreData工具类
###### 建立单例对象
 * 单例的实现
<pre> +(instancetype)shareManager{
    
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
} </pre>

- 单例方法中什么时候需要实现 allocWithZone: 方法？
   + 如果单例对象提供的方法，允许用户进行私人定制，则无需实现 allocWithZone:，例如：NSURLSession
   + 如果单例对象中提供的操作涉及到线程安全，并且确定没有定制需求，则应该实现 allocWithZone: 方法
   
#### Core Data Stack 相关方法
* 新建 Model.xcdatamodeld，注意文件名可以随便写，并且建立 Person 实体
* 从 AppDelegate 复制 managedObjectContext

 ``` 
 // 创建一个只读上下文本属性
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

```
* 利用 @synthesize 指定成员变量

```
@synthesize managedObjectContext = _managedObjectContext;

``` 

*  将 persistentStoreCoordinator 和 managedObjectModel 中的关键代码顺序复制到 managedObjectContext 的 getter 方法中


```
- (NSManagedObjectContext *)managedObjectContext {

    // 返回已经绑定到`持久化存储调度器`的管理对象上下文
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    // 数据模型的 URL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    // 从 Bundle 加载对象模型
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    // 指定保存在磁盘的数据库文件 URL
    NSURL *applicationURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationURL URLByAppendingPathComponent:dbName];

    if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:NULL] == nil) {
        NSLog(@"创建数据库错误");
        return nil;
    }
    // 创建管理对象上下文，并且指定并发类型
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 设置管理上下文的存储调度器
    [_managedObjectContext setPersistentStoreCoordinator:psc];

    return _managedObjectContext;
}

```

#### 思维导图如下：
![](http://c.picphotos.baidu.com/album/s%3D1100%3Bq%3D90/sign=40d998200e24ab18e416e53605caddbc/e850352ac65c103841fcb3c4b5119313b07e8931.jpg)

* 复制并修改 saveContext 方法

```
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


```
 

