//
//  LocalMusicView.m
//  music
//
//  Created by autobot on 16/1/25.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicView.h"
#import "Masonry.h"
#import "LocalMusicPickViewCell.h"
#import "LocalMusicSpeView.h"
#import "LocalMusicPlayerTool.h"
#import <MediaPlayer/MediaPlayer.h>
@interface LocalMusicView()
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)LocalMusicPlayerTool *musicManager;
@property (nonatomic, assign)NSInteger songsItem;
@property (nonatomic, strong)UIImageView *backgroundImage;
@property (nonatomic, strong)UIImageView *albumImage;
@end


@implementation LocalMusicView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _backgroundImage.image = [UIImage imageNamed:@"bg_drving_music.jpg"];
    _backgroundImage.userInteractionEnabled = YES;
    [self addSubview:_backgroundImage];
    _albumView = [[LocalMusicAlbumLyricView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 400)];
    _albumView.hidden = YES;
    [self addSubview:_albumView];
    _bgView = [[UIView alloc]initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor colorWithRed:19/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    _bgView.layer.cornerRadius = 3;
    [self addSubview:_bgView];
    _musicPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [self addSubview:_musicPicker];
    _label = [[UILabel alloc]initWithFrame:CGRectZero];
    _label.layer.masksToBounds = YES;
    _label.layer.cornerRadius = 5;
    _label.layer.borderColor = [UIColor colorWithRed:0/255.0 green:184/255.0 blue:235/255.0 alpha:1].CGColor;
    _label.layer.borderWidth = 2;
    _label.userInteractionEnabled = YES;
    [self addSubview:_label];
    _labelcell = [[LocalMusicPickViewCell alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width-60, 35)];
    [_label addSubview:_labelcell];
    _labelcell.hidden = YES;
    _iconImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iconImage setImage:[UIImage imageNamed:@"ic_drving_music_note"] forState:UIControlStateNormal];
    [_iconImage addTarget:self action:@selector(showAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [_label addSubview:_iconImage];
    _currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:12.f];
    _currentTimeLabel.text = @"00:00";
    [self addSubview:_currentTimeLabel];
    _progress = [[UISlider alloc]initWithFrame:CGRectZero];
    _progress.minimumTrackTintColor = [UIColor colorWithRed:0/255.0 green:184/255.0 blue:235/255.0 alpha:1];
    _progress.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:1];
    [_progress setThumbImage:[UIImage imageNamed:@"ic_drving_music_handle"] forState:UIControlStateNormal];
    [_progress addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_progress];
    _totalTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.font = [UIFont systemFontOfSize:12.f];
    _totalTimeLabel.text = @"00:00";
    [self addSubview:_totalTimeLabel];
    _spcView = [[LocalMusicSpeView alloc]initWithFrame:CGRectZero];
    [_label addSubview:_spcView];
    _play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_play setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishi"] forState:UIControlStateNormal];
    [_play setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqizanting"] forState:UIControlStateSelected];
    [_play addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_play];
    _last = [UIButton buttonWithType:UIButtonTypeCustom];
    [_last setImage:[UIImage imageNamed:@"iconfont-zhutishangyiqu"] forState:UIControlStateNormal];
    [_last addTarget:self action:@selector(lastButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_last];
    _next = [UIButton buttonWithType:UIButtonTypeCustom];
    [_next setImage:[UIImage imageNamed:@"iconfont-zhutixiayiqu"] forState:UIControlStateNormal];
    [_next addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_next];
    
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_musicPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-40);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-40);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.equalTo(@55);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-40);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.equalTo(@55);
    }];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label);
        make.left.equalTo(_label).offset(25);
    }];
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-90);
        make.width.equalTo(@(self.frame.size.width-90));
        make.height.equalTo(@44);
    }];
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_progress.mas_left).offset(-5);
        make.width.equalTo(@35);
        make.centerY.equalTo(_progress);
    }];
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_progress);
        make.width.equalTo(@35);
        make.left.equalTo(_progress.mas_right).offset(5);
    }];
    [_spcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label);
        make.right.equalTo(_label).offset(-30);
        make.height.and.width.equalTo(@20);
    }];
    
    [_play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    [_last mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_play);
        make.right.equalTo(_play.mas_left).offset(-30);
    }];
    [_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_play);
        make.left.equalTo(_play.mas_right).offset(30);
    }];
    
}

- (void)showAlbum:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(localMusicViewDidShowAlbum:)]) {
        [self.delegate localMusicViewDidShowAlbum:sender];
    }
}

- (void)changeProgress:(UISlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(localMusicViewDidChangeProgress:)]) {
        [self.delegate localMusicViewDidChangeProgress:sender];
    }
}

- (void)playButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(localMusicViewDidTouchPlayButton:)]) {
        [self.delegate localMusicViewDidTouchPlayButton:sender];
    }
}

- (void)lastButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(localMusicViewDidTouchLastButton:)]) {
        [self.delegate localMusicViewDidTouchLastButton:sender];
    }
}

- (void)nextButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(localMusicViewDidTouchNextButton:)]) {
        [self.delegate localMusicViewDidTouchNextButton:sender];
    }
}


@end
