//
//  ViewController.m
//  Push
//
//  Created by LinShang on 16/4/6.
//  Copyright © 2016年 LinShang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UILabel *alertLable;
@property(nonatomic,strong)UILabel *number;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"sound %@",NSHomeDirectory());
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"userinfo" object:nil];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 50, 35)];
    lable.text = @"消息";
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];

    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 70, 35)];
    num.text = @"icon气泡";
    num.textColor = [UIColor blackColor];
    [self.view addSubview:num];
        
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)notice:(NSNotification *)no
{
    
    NSDictionary *dic = no.userInfo;
    NSLog(@"dic : %@",dic);
    NSString *alert;
    alert = nil;
    [self.alertLable removeFromSuperview];
    
    
    NSString *badge;
    badge = nil;
    [self.number removeFromSuperview];
    
    alert = [dic objectForKey:@"alert"];
    badge = [NSString stringWithFormat:@"%@",[dic objectForKey:@"badge"]];

//    alert = [dic objectForKey:@"body"];
//    badge = [NSString stringWithFormat:@"%@",[dic objectForKey:@"action-loc-key"]];
    
    self.alertLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 250, 90)];
    self.alertLable.text = alert;
    self.alertLable.textColor = [UIColor blackColor];
    self.alertLable.numberOfLines = 0;
    self.alertLable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.alertLable];
    
    
    
    self.number = [[UILabel alloc] initWithFrame:CGRectMake(95, 200, 250, 35)];
    self.number.text = badge;
    self.number.textColor = [UIColor blackColor];
    self.number.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.number];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
