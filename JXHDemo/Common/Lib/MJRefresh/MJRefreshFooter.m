//
//  MJRefreshFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshFooter.h"
#import "MJRefreshConst.h"
#import "UIScrollView+MJExtension.h"
#import "MJRefreshHeader.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import <objc/message.h>

@interface MJRefreshFooter()
/** 显示状态文字的标签 */
@property (weak, nonatomic) UILabel *stateLabel;
/** 点击可以加载更多 */
@property (weak, nonatomic) UIButton *loadMoreButton;
/** 没有更多的数据 */
@property (weak, nonatomic) UILabel *noMoreLabel;
@end

@implementation MJRefreshFooter
#pragma mark - 懒加载
- (UIButton *)loadMoreButton
{
    if (!_loadMoreButton) {
        UIButton *loadMoreButton = [[UIButton alloc] init];
        loadMoreButton.backgroundColor = [UIColor clearColor];
        [loadMoreButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadMoreButton = loadMoreButton];
    }
    return _loadMoreButton;
}

- (UILabel *)noMoreLabel
{
    if (!_noMoreLabel) {
        UILabel *noMoreLabel = [[UILabel alloc] init];
        noMoreLabel.backgroundColor = [UIColor clearColor];
        noMoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_noMoreLabel = noMoreLabel];
    }
    return _noMoreLabel;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel = stateLabel];
    }
    return _stateLabel;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 默认底部控件100%出现时才会自动刷新
        self.appearencePercentTriggerAutoRefresh = 1.0;
        
        // 设置为默认状态
        self.automaticallyRefresh = YES;
        self.state = MJRefreshFooterStateIdle;
        
        // 初始化文字
        [self setTitle:MJRefreshFooterStateIdleText forState:MJRefreshFooterStateIdle];
        [self setTitle:MJRefreshFooterStateRefreshingText forState:MJRefreshFooterStateRefreshing];
        [self setTitle:MJRefreshFooterStateNoMoreDataText forState:MJRefreshFooterStateNoMoreData];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MJRefreshContentSize context:nil];
    [self.superview removeObserver:self forKeyPath:MJRefreshPanState context:nil];
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:MJRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:MJRefreshPanState options:NSKeyValueObservingOptionNew context:nil];
        
        self.mj_h = MJRefreshFooterHeight;
        _scrollView.mj_insetB += self.mj_h;
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.loadMoreButton.frame = self.bounds;
    self.stateLabel.frame = self.bounds;
    self.noMoreLabel.frame = self.bounds;
}

#pragma mark - 私有方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.state == MJRefreshFooterStateNoMoreData) return;
    
    // 根据contentOffset调整state
    if ([keyPath isEqualToString:MJRefreshPanState]) {
        if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
            if (_scrollView.mj_insetT + _scrollView.mj_contentSizeH <= _scrollView.mj_h) {  // 不够一个屏幕
                if (_scrollView.mj_offsetY > - _scrollView.mj_insetT) { // 向上拽
                    self.state = MJRefreshFooterStateRefreshing;
                }
            } else { // 超出一个屏幕
                if (_scrollView.mj_offsetY > self.mj_y + _scrollView.mj_insetB - _scrollView.mj_h) {
                    self.state = MJRefreshFooterStateRefreshing;
                }
            }
        }
    } else if ([keyPath isEqualToString:MJRefreshContentOffset]) {
        if (self.state != MJRefreshFooterStateRefreshing && self.automaticallyRefresh) {
            [self adjustStateWithContentOffset];
        }
    } else if ([keyPath isEqualToString:MJRefreshContentSize]) {
        [self adjustFrameWithContentSize];
    }
}

#pragma mark 根据contentOffset调整state
- (void)adjustStateWithContentOffset
{
    if (self.mj_y == 0) return;
    
    if (_scrollView.mj_insetT + _scrollView.mj_contentSizeH > _scrollView.mj_h) { // 内容超过一个屏幕
        if (_scrollView.mj_offsetY > self.mj_y - _scrollView.mj_h + self.mj_h * self.appearencePercentTriggerAutoRefresh) {
            // 当底部刷新控件完全出现时，才刷新
            self.state = MJRefreshFooterStateRefreshing;
        }
    }
}

- (void)adjustFrameWithContentSize
{
    // 设置位置
    self.mj_y = _scrollView.mj_contentSizeH;
}

- (void)buttonClick
{
    self.state = MJRefreshFooterStateRefreshing;
}

#pragma mark - 公共方法
- (void)setHidden:(BOOL)hidden
{
    if (!self.isHidden && hidden) {
        self.state = MJRefreshFooterStateIdle;
        _scrollView.mj_insetB -= self.mj_h;
    } else if (self.isHidden && !hidden) {
        _scrollView.mj_insetB += self.mj_h;
        
        [self adjustFrameWithContentSize];
    }
    
    [super setHidden:hidden];
}

- (void)beginRefreshing
{
    self.state = MJRefreshFooterStateRefreshing;
}

- (void)endRefreshing
{
    self.state = MJRefreshFooterStateIdle;
}

- (BOOL)isRefreshing
{
    return self.state == MJRefreshFooterStateRefreshing;
}

- (void)noticeNoMoreData
{
    self.state = MJRefreshFooterStateNoMoreData;
}

- (void)setTitle:(NSString *)title forState:(MJRefreshFooterState)state
{
    if (title == nil) return;
    
    // 刷新当前状态的文字
    switch (state) {
        case MJRefreshFooterStateIdle:
            [self.loadMoreButton setTitle:title forState:UIControlStateNormal];
            break;
            
        case MJRefreshFooterStateRefreshing:
            self.stateLabel.text = title;
            break;
            
        case MJRefreshFooterStateNoMoreData:
            self.noMoreLabel.text = title;
            break;
            
        default:
            break;
    }
}

- (void)setState:(MJRefreshFooterState)state
{
    if (_state == state) return;
    
    _state = state;
    
    switch (state) {
        case MJRefreshFooterStateIdle:
            self.noMoreLabel.hidden = YES;
            self.stateLabel.hidden = YES;
            self.loadMoreButton.hidden = NO;
            break;
            
        case MJRefreshFooterStateRefreshing:
            self.loadMoreButton.hidden = YES;
            self.noMoreLabel.hidden = YES;
            if (!self.stateHidden) self.stateLabel.hidden = NO;
            if (self.refreshingBlock) {
                self.refreshingBlock();
            }
            if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
                msgSend(msgTarget(self.refreshingTarget), self.refreshingAction, self);
            }
            break;
            
        case MJRefreshFooterStateNoMoreData:
            self.loadMoreButton.hidden = YES;
            self.noMoreLabel.hidden = NO;
            self.stateLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    self.stateLabel.textColor = textColor;
    [self.loadMoreButton setTitleColor:textColor forState:UIControlStateNormal];
    self.noMoreLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.loadMoreButton.titleLabel.font = font;
    self.noMoreLabel.font = font;
    self.stateLabel.font = font;
}

- (void)setStateHidden:(BOOL)stateHidden
{
    _stateHidden = stateHidden;
    
    self.stateLabel.hidden = stateHidden;
    [self setNeedsLayout];
}
@end
