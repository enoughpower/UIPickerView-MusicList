//
//  LocalMusicSpeView.m
//  music
//
//  Created by autobot on 16/1/26.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicSpeView.h"
#import "Masonry.h"
@interface LocalMusicSpeView ()
@property (nonatomic, strong)UIImageView *view1;
@property (nonatomic, strong)UIImageView *view2;
@property (nonatomic, strong)UIImageView *view3;
@property (nonatomic, strong)UIImageView *view4;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation LocalMusicSpeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _view1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _view1.image = [UIImage imageNamed:@"ic_drving_music_ing"];
    [self addSubview:_view1];
    _view2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _view2.image = [UIImage imageNamed:@"ic_drving_music_ing"];
    [self addSubview:_view2];
    _view3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _view3.image = [UIImage imageNamed:@"ic_drving_music_ing"];
    [self addSubview:_view3];
    _view4 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _view4.image = [UIImage imageNamed:@"ic_drving_music_ing"];
    [self addSubview:_view4];
    
    CGFloat offset = (20 - 2*4) / 3;
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
//        make.height.equalTo(0);
    }];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1.mas_right).offset(offset);
        make.bottom.equalTo(self);
        //        make.height.equalTo(0);
    }];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view2.mas_right).offset(offset);
        make.bottom.equalTo(self);
        //        make.height.equalTo(0);
    }];
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view3.mas_right).offset(offset);
        make.bottom.equalTo(self);
        //        make.height.equalTo(0);
    }];
}

- (void)startPlay
{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeHeight:) userInfo:nil repeats:YES];
}
- (void)stopPlay
{
    [self clearHeight];
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)changeHeight:(NSTimer *)timer
{
    CGFloat height1 = arc4random()%20+1;
    CGFloat height2 = arc4random()%20+1;
    CGFloat height3 = arc4random()%20+1;
    CGFloat height4 = arc4random()%20+1;
    [_view1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height1));
    }];
    [_view2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height2));
    }];
    [_view3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height3));
    }];
    [_view4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height4));
    }];
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)clearHeight
{
    [_view1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
    }];
    [_view2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
    }];
    [_view3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
    }];
    [_view4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
    }];
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];

}
@end
