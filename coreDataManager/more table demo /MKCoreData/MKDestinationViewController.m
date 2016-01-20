//
//  MKDestinationViewController.m
//  MKCoreData
//
//  Created by liulujie on 16/1/14.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import "MKDestinationViewController.h"
#import "MKTilteTableViewController.h"
#import "MKCoreDataManager.h"
#import "Title.h"
#import "Person.h"


@interface MKDestinationViewController ()<UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *brithdayText;
@property (weak, nonatomic) IBOutlet UITextField *dectText;

@property(nonatomic,strong) NSDateFormatter *dateFormatter;



@property (nonatomic) Title *selectedTitle;

@end

@implementation MKDestinationViewController

#pragma mark 懒加载数据
-(NSDateFormatter *)dateFormatter{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    }
    return _dateFormatter;
}

#pragma mark 函数入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.brithdayText.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];

    if (self.person != nil) {
        self.nameText.text = self.person.name;
        self.titleText.text = self.person.title.tilteName;
        self.brithdayText.text = [self.dateFormatter stringFromDate:self.person.birthday];
        self.dectText.text = self.person.desc;
    }
    // 添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTitle:) name:HMSelectTitleNotification object:nil];
    
    
}


-(void)selectTitle:(NSNotification *)noti{
    
    self.selectedTitle = noti.object;
    
    // 设置文本框
    self.titleText.text = self.selectedTitle.tilteName;
    
}

-(void)selectedDate:(UIDatePicker *)picker{
    self.brithdayText.text = [self.dateFormatter stringFromDate:picker.date];
}

#pragma mark
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segueIndentifier"]) {
        UIPopoverPresentationController *presentctionVC = segue.destinationViewController.popoverPresentationController;
        presentctionVC.popoverLayoutMargins = UIEdgeInsetsMake(20, 20, 20, 20);
        
          presentctionVC.delegate = self;
    }
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (IBAction)saveNumber:(id)sender {
    
    Person *person1;
    
    if (self.person == nil) {
        if (self.nameText.text.length > 0 && self.titleText.text.length > 0) {
            
            person1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[MKCoreDataManager shareManager].managedObjectContext];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        person1 = self.person;
    }
    
    person1.name = self.nameText.text;
    
    if (self.selectedTitle == nil) {
        
         if (self.nameText.text.length > 0 && self.titleText.text.length > 0) {
        Title *title = [NSEntityDescription insertNewObjectForEntityForName:@"Title" inManagedObjectContext:[MKCoreDataManager shareManager].managedObjectContext];
        
        title.tilteName = self.titleText.text;
        
        person1.title = title;
         }
        
    }else{
        
        if (self.selectedTitle.tilteName != nil) {
            person1.title = self.selectedTitle;
        }
    }
    person1.birthday = [self.dateFormatter dateFromString:self.brithdayText.text];
    person1.desc = self.dectText.text;
    
        //将数据保存到数据库中
//    if (self.nameText.text.length > 0 && self.titleText.text.length > 0) {

        [[MKCoreDataManager shareManager] saveContext];

    // 退出当前的页面
    [self.navigationController popViewControllerAnimated:YES];
}

@end
