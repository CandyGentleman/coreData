//
//  MKDestinationViewController.m
//  MKCoreData
//
//  Created by liulujie on 16/1/14.
//  Copyright © 2016年 liulujie. All rights reserved.
//

#import "MKDestinationViewController.h"
#import "MKCoreDataManager.h"
#import "Person.h"


@interface MKDestinationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *tiitle;
@property (weak, nonatomic) IBOutlet UITextField *textHeight;
@property (weak, nonatomic) IBOutlet UITextField *textAge;
@end

@implementation MKDestinationViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.person != nil) {
        self.textName.text = self.person.name;

        self.tiitle.text = self.person.title;
        self.textHeight.text = [NSString stringWithFormat:@"%@" ,self.person.height];
        self.textAge.text = [NSString stringWithFormat:@"%@",self.person.age ];
    }
}



- (IBAction)saveNumber:(id)sender {
    Person *person;
    if (self.person == nil) {
          person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[MKCoreDataManager shareManager].managedObjectContext];
    }else{
        person = self.person;
    }
   person.name = self.textName.text;
   person.title = self.tiitle.text;
   person.height = [NSNumber numberWithFloat:self.textHeight.text.floatValue];
    person.age = [NSNumber numberWithInt:self.textAge.text.intValue];
  
    //将数据保存到数据库中
    [[MKCoreDataManager shareManager] saveContext];
    
    // 退出当前的页面
    [self.navigationController popViewControllerAnimated:YES];
}



@end