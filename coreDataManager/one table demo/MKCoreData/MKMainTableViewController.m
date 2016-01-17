//
//  MKMainTableViewController.m
//  MKCoreData
//
//  Created by liulujie on 16/1/14.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import "MKMainTableViewController.h"
#import "MKDestinationViewController.h"
#import "MKCoreDataManager.h"
#import "Person.h"

@interface MKMainTableViewController ()<NSFetchedResultsControllerDelegate>

// 定义一个查询结果集控制器
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation MKMainTableViewController


-(NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];

    fetchRequest.sortDescriptors = @[sort1,sort2];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[MKCoreDataManager shareManager].managedObjectContext sectionNameKeyPath:@"title" cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


#pragma mark 添加按钮的点击事件

- (IBAction)AddBtnClick:(id)sender {
    [self performSegueWithIdentifier:@"identifitersegue" sender:nil];
}

// 控制器的跳转传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MKDestinationViewController class]]) {
        
        NSIndexPath *indexpath = sender;
        
        
        if (indexpath != nil) {
            
            MKDestinationViewController *destination = segue.destinationViewController;
            destination.person = [self.fetchedResultsController.sections[indexpath.section] objects][indexpath.row];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
       // 插入数据
//    [self createDemoData];
    
    [self.fetchedResultsController performFetch:nil];
    
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.fetchedResultsController.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.fetchedResultsController.sections[section] name];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedResultsController.sections[section] objects] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resuseCell"];
    
    Person *person = [self.fetchedResultsController.sections[indexPath.section] objects][indexPath.row];
    
    cell.textLabel.text = person.name;
    
    return cell;
}

#pragma mark Table view delegete

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"identifitersegue" sender:indexPath];
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}



#pragma mark - 插入数据的代码

- (void)createDemoData {
    
    NSArray *names = @[@"zhangsan", @"lisi", @"zhaoliu", @"xiaofang"];
    NSArray *titles = @[@"boss", @"manager", @"developer"];
    
    for (int i = 0; i < 100; i++) {
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[MKCoreDataManager shareManager].managedObjectContext];
        
        person.name = [names[arc4random_uniform(4)] stringByAppendingFormat:@" - %06d", arc4random_uniform(100000)];
        person.title = titles[arc4random_uniform(3)];
        person.age = @(18 + arc4random_uniform(20));
        person.height = @(1.5 + (CGFloat)arc4random_uniform(5) / 10);
    }
    
    // 保存数据
    [[MKCoreDataManager shareManager] saveContext];
    
    NSLog(@"OK!");
}


@end