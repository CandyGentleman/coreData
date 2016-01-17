//
//  MKTilteTableViewController.m
//  MKCoreData
//
//  Created by liulujie on 16/1/16.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import "MKTilteTableViewController.h"
#import "MKCoreDataManager.h"
#import "Title.h"

NSString *const HMSelectTitleNotification  = @"HMSelectTitleNotification";

@interface MKTilteTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MKTilteTableViewController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Title"];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tilteName" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[MKCoreDataManager shareManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fetchedResultsController performFetch:NULL];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.fetchedResultsController.fetchedObjects[indexPath.row] tilteName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Title *title = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HMSelectTitleNotification object:title];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)addTitleBtnClick:(id)sender {
    
    UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:@"请输入头衔" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [AlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      textField.placeholder = @"请输入你的添加的头衔";
    }];
    
    [AlertVC addAction:[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:nil]];
    
    [AlertVC addAction:[UIAlertAction actionWithTitle:@"ture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = AlertVC.textFields[0];
        if (textField.hasText) {

            Title *title = [NSEntityDescription insertNewObjectForEntityForName:@"Title" inManagedObjectContext:[MKCoreDataManager shareManager].managedObjectContext];
            
            title.tilteName = textField.text;
            
            [[MKCoreDataManager shareManager] saveContext];
        }
    }]];
    
    [self presentViewController:AlertVC animated:YES completion:nil];
    
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}

@end
