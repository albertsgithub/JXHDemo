//
//  EditTypeViewController.m
//  slyy_department_edition
//
//  Created by 919575700@qq.com on 12/18/15.
//  Copyright © 2015 eeesysmini2. All rights reserved.
//

#import "EditTypeViewController.h"

@interface EditTypeViewController ()

@end

@implementation EditTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑就诊类型";
    // 设置数据资源
    [self setDataSource];
    // 设置表头提示文字视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ApplicationW, 35)];
    [headerView setBackgroundColor:RGBColor(220, 220, 220)];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    tipLabel.text = @"《《《   向左滑动删除就诊类型";
    [tipLabel sizeToFit];
    tipLabel.textColor = [UIColor grayColor];
    [headerView addSubview:tipLabel];
    [self.tableView setTableHeaderView:headerView];
}

/**
 *  设置数据资源
 */
- (void)setDataSource {
    // 读取沙盒数据
    NSArray *typeDataArray = [[NSArray alloc] initWithContentsOfFile:SLDignoseTypeDomainPath];
    // 把数据封装进表格数据单元组件
    NSMutableArray *Items = [[NSMutableArray alloc] init];
    for (NSString *typeName in typeDataArray) {
        ESListItem *item = [[ESListItem alloc] init];
        item.title = typeName;
        [Items addObject:item];
    }
    self.items = Items;
}

/**
 *  删除指定就诊类型
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除沙盒数据
    NSMutableArray *domainArray = [[NSMutableArray alloc] initWithContentsOfFile:SLDignoseTypeDomainPath];
    [domainArray removeObjectAtIndex:indexPath.row];
    [domainArray writeToFile:SLDignoseTypeDomainPath atomically:YES];
    // 刷新数据显示
    [self setDataSource];
    [self.tableView reloadData];
}

@end
