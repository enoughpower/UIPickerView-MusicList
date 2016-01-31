//
//  LocalMusicView.h
//  music
//
//  Created by autobot on 16/1/25.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalMusicPickViewCell.h"
#import "LocalMusicSpeView.h"
#import "LocalMusicAlbumLyricView.h"

@protocol LocalMusicViewDelegate <NSObject>
- (void)localMusicViewDidTouchPlayButton:(UIButton *)playButton;
- (void)localMusicViewDidTouchNextButton:(UIButton *)nextButton;
- (void)localMusicViewDidTouchLastButton:(UIButton *)lastButton;
- (void)localMusicViewDidChangeProgress:(UISlider *)progress;
- (void)localMusicViewDidShowAlbum:(UIButton *)showAlbum;
@end


@interface LocalMusicView : UIView
@property (nonatomic, strong)UIPickerView *musicPicker;
@property (nonatomic, strong)UILabel *currentTimeLabel;
@property (nonatomic, strong)UISlider *progress;
@property (nonatomic, strong)UILabel *totalTimeLabel;
@property (nonatomic, strong)LocalMusicSpeView *spcView;
@property (nonatomic, strong)LocalMusicAlbumLyricView *albumView;
@property (nonatomic, strong)LocalMusicPickViewCell *labelcell;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, weak)id<LocalMusicViewDelegate>delegate;
@property (nonatomic, strong)UIButton *iconImage;
@property (nonatomic, strong)UIButton *play;
@property (nonatomic, strong)UIButton *last;
@property (nonatomic, strong)UIButton *next;

@end
