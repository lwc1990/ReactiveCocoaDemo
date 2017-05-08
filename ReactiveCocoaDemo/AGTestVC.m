//
//  AGTestVC.m
//  agan-fruit
//
//  Created by syl on 2017/4/28.
//  Copyright © 2017年 agan-fruil. All rights reserved.
//

#import "AGTestVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AGSqliteUtils.h"
#import "AGFMDBUtils.h"
@interface AGTestVC ()<UITextFieldDelegate,AGSqliteUtilsDelegate>
@property (nonatomic,strong) UITextField *userNameText,*passWordText;
@property (nonatomic,strong) UIButton *cancelBtn,*signInBtn;
@end
@implementation AGTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self testSqlite3];
    //    [self createLoginUI];
    //    [self signInControl];
    
}
-(void)afterExecSql:(sqlite3_stmt *)stmt
{
    if (!stmt) return;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        char *name = (char*)sqlite3_column_text(stmt, 1);
        NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
        
        int age = sqlite3_column_int(stmt, 2);
        
        char *address = (char*)sqlite3_column_text(stmt, 3);
        NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
        
        NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
    }
}
-(void)testSqlite3
{
    BOOL execSucess = [AGSqliteUtils noQueryExec:@"testDB" execSql:@"CREATE TABLE IF NOT EXISTS testInfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)"];
    if (!execSucess) return;
    BOOL insertSuccess = [AGSqliteUtils noQueryExec:@"testDB" execSql:@"INSERT INTO testInfo ('name', 'age', 'address') VALUES ('张三',23, '西城区')"];
    if (!insertSuccess) return;
    [AGSqliteUtils QueryExec:@"testDB" execSql:@"select * from testInfo" queryObject:self];
    
}
-(void)testFMDB
{
    FMDatabase *fDB = [AGFMDBUtils dataBase:@"fDataBase"];
    
}
-(void)createLoginUI
{
    if (!self.userNameText)
    {
        self.userNameText = [self creatTextField];
        [self.userNameText setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - 50,100,100,40)];
    }
    if (!self.passWordText)
    {
        self.passWordText = [self creatTextField];
        [self.passWordText setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - 50,CGRectGetMaxY(self.userNameText.frame) + 40,100,40)];
    }
    if (!self.cancelBtn)
    {
        self.cancelBtn = [self creatBtn:@"取消"];
        [self.cancelBtn setFrame:CGRectMake(CGRectGetMinX(self.userNameText.frame),CGRectGetMaxY(self.passWordText.frame)+40,40,30)];
        [self.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!self.signInBtn)
    {
        self.signInBtn = [self creatBtn:@"登陆"];
        
        [self.signInBtn setFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 20,CGRectGetMinY(self.cancelBtn.frame),40,30)];
        [self.signInBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
/*
 * 登陆界面的所有信号控制的总体逻辑
 * 判断用户名输入的合法性
 * 判断密码输入的合法性
 * 登陆按钮是否可点击
 */
-(void)signInControl
{
    //用户名的合法性
    RACSignal *validUserNameSignal = [self.userNameText.rac_textSignal map:^id(NSString * value) {
        return @([self isValidUserName:value]);
    }];
    //输入的内容会根据输入的合法性改变字体颜色
    RAC(self.userNameText,textColor) = [validUserNameSignal map:^id(NSNumber *isValidateUserName){
        return [isValidateUserName boolValue]?[UIColor blackColor]:[UIColor redColor];
    }];
    //密码的合法性
    RACSignal *validPassWordSignal = [self.passWordText.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPassword:value]);
    }];
    RAC(self.passWordText,textColor) = [validPassWordSignal map:^id(NSNumber *isValidPassWord) {
        return [isValidPassWord boolValue]?[UIColor blackColor]:[UIColor redColor];
    }];
    //组合信号，判断登陆按钮的可点性
    RACSignal *combineSignalForSigInBtn = [RACSignal combineLatest:@[validUserNameSignal,validPassWordSignal] reduce:^id(NSNumber *isValidUserName,NSNumber *isValidPassWord){
        return @([isValidUserName boolValue] && [isValidPassWord boolValue]);
    }];
    [combineSignalForSigInBtn subscribeNext:^(NSNumber *enabled) {
        self.signInBtn.enabled = [enabled boolValue];
        self.signInBtn.backgroundColor = [enabled boolValue]?[UIColor grayColor]:[UIColor lightGrayColor];
    }];
    
    
}
//判断用户名的合法性
-(BOOL)isValidUserName:(NSString *)value
{
    
    if (value.length > 6 && value.length < 18) {
        return YES;
    }
    return NO;
}
//判断密码的合法性
-(BOOL)isValidPassword:(NSString *)value
{
    if (value.length > 6 && value.length < 18)
    {
        return YES;
    }
    return NO;
}
-(UITextField *)creatTextField
{
    UITextField *tF = [[UITextField alloc]init];
    tF.backgroundColor = [UIColor whiteColor];
    tF.borderStyle = UITextBorderStyleRoundedRect;
    tF.delegate = self;
    tF.clearsContextBeforeDrawing = YES;
    tF.clearButtonMode = UITextFieldViewModeWhileEditing;
    tF.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:tF];
    return tF;
}
-(UIButton *)creatBtn:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [self.view addSubview:btn];
    return btn;
}
-(void)btnClick:(UIButton *)btn
{
    if ([btn isEqual:self.signInBtn])
    {
        NSLog(@"用户名：%@,密码：%@",self.userNameText.text,self.passWordText.text);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
