//
//  TestViewController.m
//  JXHDemo
//
//  Created by 919575700@qq.com on 10/23/15.
//  Copyright (c) 2015 Jiangxh. All rights reserved.
//

#import "TestViewController.h"
#import "UIAlertView+DIY.h"

#import "RequestSingleton.h"
@interface TestViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(230, 230, 230);
    
    // 1.测试sizeToFit
    //[self sizeToFit];
    
    // 2.测试DIY alertView
    //[self alertViewTest];
    
    // 4.NSString
    //[self stringTest];
    
    // 字符串与json的相互转换
    //[self testJson];
    
    // 测试原生网络请求
    
}
#import "RequestSingleton.h"
/**
 * 原生网络请求测试示例
 */
- (void)request {
    // 1.服务器url接口
    NSString *url = @"";
    // 2.制作参数
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:@"919575700@qq.com" forKey:@"username"];
    [paramDic setObject:@"jxh123" forKey:@"password"];
    // 转成json字符串，用到MJExtension归档插件
    NSString *param = [paramDic JSONString];
    // post请求
    [[RequestSingleton Ins] POST:url param:param success:^(id json) {
        // 请求成功
    } failure:^(NSError *error) {
        // 请求错误
    }];
}


/**
 *  字符串与json的相互转换
 */
- (void)testJson {
    //获取标准函数对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 读取字符串数据
    NSString *data;
    NSMutableArray *users = [[NSMutableArray alloc]init];
    
    //制作新账户数据
    NSMutableDictionary *newUser = [[NSMutableDictionary alloc]init];
    [newUser setObject:@"919575700" forKey:@"username"];
    [newUser setObject:@"123456" forKey:@"paswword"];
    [users addObject:newUser];
    NSString *s = [users JSONString];
    NSLog(@"存入的json字符串：%@",s);
    [defaults setObject:s forKey:@"sdkUsers"];
    
    // 读取字符串数据
    data = [defaults objectForKey:@"sdkUsers"];
    // 字符串转json
    if (data) {
        users = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    NSLog(@"读取的json对象：%@",users);
}

/**
 *  测试sizeToFit
 */
- (void)sizeToFit {
    /**
     *  有时候UIView的尺寸不好直接设置，需要根据内容来改变UIView的尺寸，这就需要使用sizeToFit方法。
     *  以UILabel为例，使用sizeToFit方法后，可以根据UILabel中字符串大小自动调整UILabel的大小
     *  UIButton使用sizeToFit方法，会根据button标题的大小自动调整UIButton的大小
     */
    //零尺寸UILabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    //设置中心
    label.center = CGPointMake(0, self.view.center.y);
    //label背景色，便于看其尺寸
    [label setBackgroundColor:[UIColor grayColor]];
    //label字体颜色
    label.textColor = [UIColor whiteColor];
    //label文字内容
    label.text = @"UILabel会根据我的长度变化大小";
    //sizeToFit
    [label sizeToFit];
    //显示label
    [self.view addSubview:label];
}
/**
 * 测试DIY alertView
 */
- (void)alertViewTest {
    //定一个提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DIY" message:@"这个应该不显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    // 1.自定义小标题label
    UILabel *title = [[UILabel alloc] init];
    //文字内容
    [title setText:@"小标题"];
    //文字颜色
    [title setTextColor:[UIColor blueColor]];
    //文字字体
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    [self autoSetLabelFrame:title];
    //添加居左的label
    //[alert addLeftAlignmentLabel:title];
    // 2.自定义正文label
    UILabel *label = [[UILabel alloc] init];
    //文字内容
    [label setText:@"自定义的提示内容哦为了显示换行我多写一点，不行再多写一点，换行了没，没换我再写一点。"];
    //[self autoSetLabelFrame:label];
    //[self autoSetNextOriginFromView:title toView:label];
    //添加居左的label
    [alert addLeftAlignmentLabel:label];
    //初始化提示框的子视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [view addSubview:title];
    [view addSubview:label];
    //[alert addUIView:view];
    //显示提示框
    [alert show];
}
/**
 * 自动设置UILabel的段落尺寸并居左
 */
- (void)autoSetLabelFrame: (UILabel *)label {
    CGSize size = [label.text sizeWithFont:label.font maxW:240];
    [label setFrame:CGRectMake(CellMargin, 0, size.width, size.height)];
    //文字换行模式
    label.lineBreakMode = NSLineBreakByWordWrapping;
    //行数
    label.numberOfLines = 0;
    //文字左对齐
    label.textAlignment = NSTextAlignmentLeft;
}
/**
 * 自动根据上一个视图设置下一个视图的原点
 */
- (void)autoSetNextOriginFromView: (UIView *)preView toView:(UIView *)nextView {
    CGRect preRect = preView.frame;
    CGSize nextSize = nextView.frame.size;
    nextView.frame = CGRectMake(preRect.origin.x, preRect.origin.y + preRect.size.height, nextSize.width, nextSize.height);
}

/**
 * stringTest
 */
- (void)stringTest {
    NSString *s = @"{\"code\":10000,\"msg\":\"参数错误\",\"desc\":null,\"data\":{}}\0\0\0\0\0\0\0";
    const char *a = [s UTF8String];
    NSString *trim = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
    NSLog(@"trim:%@", trim);
}

@end
