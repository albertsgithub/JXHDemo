//
//  MyCalenderView.h
//  demo
//
//  Created by jiangxh on 15/9/17.
//  Copyright (c) 2015年 txbydev3. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 1.日历代理协议
 */
@protocol CalendarDelegate <NSObject>

//- (void)clickedDateButton:(UIButton *)button;//点击了日期按钮，用于通知日历视图控制器
- (void)openSchedule:(NSString *)dateStr :(UIButton *)sender;//点击日期按钮之后打开事务列表,传入当前按钮

@end

/**
 * 2.日历数据源协议
 */
@protocol CalendarDataSource <NSObject>

- (BOOL)isDataForDate:(NSDate *)date;

@end

@interface MyCalenderView : UIView

// 日历当前月份标识日期
@property (nonatomic,strong) NSDate *calendarDate;
// 日历协议
@property (nonatomic,weak) id<CalendarDelegate> delegate;
// 日历数据源
@property (nonatomic,weak) id<CalendarDataSource> datasource;
// 字体
@property (nonatomic, strong) UIFont * defaultFont;
@property (nonatomic, strong) UIFont * titleFont;
// 月份和星期的字体颜色
@property (nonatomic, strong) UIColor * monthAndDayTextColor;
// 边框
@property (nonatomic, strong) UIColor * borderColor;//边框颜色
@property (nonatomic, assign) NSInteger borderWidth;//边框宽度
// 按钮颜色
@property (nonatomic, strong) UIColor * dayBgColorWithoutData;//未来日期数据的按钮的颜色
@property (nonatomic, strong) UIColor * dayBgColorWithData;//过去日期数据的按钮的颜色
@property (nonatomic, strong) UIColor * dayBgColorToday;//选中的按钮的颜色
@property (nonatomic, strong) UIColor * dayTxtColorWithoutData;//未来日期数据的字体的颜色
@property (nonatomic, strong) UIColor * dayTxtColorWithData;//过去日期数据的字体的颜色
@property (nonatomic, strong) UIColor * dayTxtColorToday;//选中的字体的颜色
@property (nonatomic, strong) UIColor * dayTxtColorNotThisMonth;//不是本月的日期的字体的颜色
@property (nonatomic) CGFloat alphaOfNotThisMonth;//不是本月的日期的字体的透明度

// 日历数组的左上角锚点
@property (nonatomic, assign) NSInteger originX;
@property (nonatomic, assign) NSInteger originY;
// 月份切换动画
@property (nonatomic, assign) UIViewAnimationOptions nextMonthAnimation;
@property (nonatomic, assign) UIViewAnimationOptions prevMonthAnimation;
// 选中的日期保留／月份标签
@property (nonatomic, assign) BOOL keepSelDayWhenMonthChange;
@property (nonatomic, assign) BOOL hideMonthLabel;

/**
 *  1.显示下一个月的日历
 */
-(void)showNextMonth;
/**
 *  2.显示上一个月的日历
 */
-(void)showPreviousMonth;
/**
 *  3.重置本月
 */
- (void)reloadCurrentMonth;

@end