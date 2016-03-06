//
//  LocalMusicController.m
//  music
//
//  Created by autobot on 16/1/25.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicController.h"
#import "LocalMusicView.h"
#import "Masonry.h"
#import "LocalMusicPlayerTool.h"
#import "LocalMusicSpeView.h"
#import "LocalMusicPickViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicInfoModel.h"
#import "UIImageView+WebCache.h"
#define kURL @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"
@interface LocalMusicController ()<LocalMusicViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,LocalMusicPlayerToolDelegate>
@property (nonatomic, strong)LocalMusicView *MusicView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)LocalMusicPlayerTool *musicManager;
@property (nonatomic, assign)NSInteger songsItem;
@end

@implementation LocalMusicController
- (void)loadView
{
    self.MusicView  = [[LocalMusicView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _MusicView;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _musicManager = [LocalMusicPlayerTool shareMusicPlay];
    _musicManager.delegate = self;
    _dataArray = [NSMutableArray array];
    _MusicView.delegate = self;
    [self initData];
    

    
}
- (void)initData
{
    _MusicView.musicPicker.dataSource = self;
    _MusicView.musicPicker.delegate = self;
    _MusicView.iconImage.enabled = NO;
    [self getMusicData];
    [_musicManager.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_MusicView.spcView stopPlay];
}

#pragma mark -- PickViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //隐藏上下两条黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    
    LocalMusicPickViewCell *cell = (LocalMusicPickViewCell *)view;
    if (!cell) {
        cell = [[LocalMusicPickViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    }
    MusicInfoModel *model = _dataArray[row];
    cell.name.text = model.name;
    cell.singer.text = model.singer;
    return cell;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _songsItem = row;
    if (_musicManager.player.rate != 0) {
        [self startPlayingSong];
    }
    LocalMusicPickViewCell *cell = (LocalMusicPickViewCell *)[pickerView viewForRow:row forComponent:component];
    MusicInfoModel *model = _dataArray[row];

    NSString *title = model.name;
    if (title.length > 26) {
        NSString *newTitle = [title substringToIndex:26];
        cell.name.text = newTitle;
    }
    
}

#pragma mark -- PlayerToolDelegate
- (void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress
{
    _MusicView.albumView.albumImage.transform = CGAffineTransformRotate(_MusicView.albumView.albumImage.transform, M_PI/180);
    _MusicView.currentTimeLabel.text = curTime;
    _MusicView.totalTimeLabel.text = totleTime;
    _MusicView.progress.value = progress;
    // 返回歌词在数组中的位置,然后根据这个位置,将tableView跳到对应的那一行.
    NSInteger index = [_musicManager getIndexFromArray];
    if (index == -1) {
        return;
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.MusicView.albumView.lyricTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    
}

- (void)MusicDidEndPlay
{
    if (self.songsItem == self.dataArray.count -1) {
        self.songsItem = 0;
    }else
    {
        self.songsItem ++;
    }
    [self startPlayingSong];
}
// 播放按钮
- (void)Play
{
    if (_dataArray.count>0) {
        if (_musicManager.player.rate == 0 ) {
            [self startPlayingSong];
            [_MusicView.spcView startPlay];
        }else{
            [_musicManager musicPause];
            [_MusicView.spcView stopPlay];
        }
    }
}
//下一曲
- (void)Next
{
    if (self.songsItem == self.dataArray.count -1) {
        self.songsItem = 0;
    }else
    {
        self.songsItem ++;
    }
    LocalMusicPickViewCell *cell = (LocalMusicPickViewCell *)[_MusicView.musicPicker viewForRow:_songsItem forComponent:0];
    MusicInfoModel *model = _dataArray[self.songsItem];
    NSString *title = model.name;
    if (title.length > 26) {
        NSString *newTitle = [title substringToIndex:26];
        cell.name.text = newTitle;
    }
    [_MusicView.musicPicker selectRow:_songsItem inComponent:0 animated:YES];
    if (_musicManager.player.rate != 0) {
        [self startPlayingSong];
    }
}
//上一曲
- (void)Last
{
    if (self.songsItem == 0) {
        self.songsItem = self.dataArray.count -1;
    }else
    {
        self.songsItem --;
    }
    LocalMusicPickViewCell *cell = (LocalMusicPickViewCell *)[_MusicView.musicPicker viewForRow:_songsItem forComponent:0];
    MusicInfoModel *model = _dataArray[self.songsItem];
    NSString *title = model.name;
    if (title.length > 26) {
        NSString *newTitle = [title substringToIndex:26];
        cell.name.text = newTitle;
    }
    [_MusicView.musicPicker selectRow:_songsItem inComponent:0 animated:YES];
    if (_musicManager.player.rate != 0) {
        [self startPlayingSong];
    }
}

// 获取音乐
- (void)getMusicData
{
//    MPMediaQuery *query = [MPMediaQuery playlistsQuery];//初始话类型 枚举
//    NSArray *tempArray = [[NSArray alloc] initWithArray:[query items]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kURL]];
        _songsItem = 0;
        for (NSDictionary *dict in tempArray) {
            MusicInfoModel *item = [[MusicInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MusicView.musicPicker reloadAllComponents];
            _MusicView.iconImage.enabled = YES;
        });
    });
}

// 开始播放
- (void)startPlayingSong
{
    MusicInfoModel *model = _dataArray[self.songsItem];
    NSString *urlStr = model.mp3Url;
    if ([urlStr isEqualToString:self.musicManager.model.mp3Url]) {
        if (_musicManager.player.rate == 0) {
            [_musicManager musicPause];
            [_musicManager musicPlay];
        }
        return;
    }
    
    LocalMusicPickViewCell *cell = (LocalMusicPickViewCell *)[_MusicView.musicPicker viewForRow:_songsItem forComponent:0];
    NSString *title = model.name;
    _MusicView.labelcell.name.text = title;
    _MusicView.labelcell.singer.text = model.singer;
    if (title.length > 26) {
        NSString *newTitle = [title substringToIndex:26];
        cell.name.text = newTitle;
        _MusicView.labelcell.name.text = newTitle;
    }
    [_MusicView.albumView.albumImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    [_MusicView.musicPicker selectRow:_songsItem inComponent:0 animated:YES];
    
    self.musicManager.model = model;
    self.MusicView.albumView.lyrics = [self.musicManager getLyricArray];
    
    [self.musicManager musicPrePlay];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:@"rate"]) {
        if ([change[@"new"] floatValue] == 0) {
            [_MusicView.spcView stopPlay];
            _MusicView.play.selected = NO;
        }else
        {
            [_MusicView.spcView startPlay];
            _MusicView.play.selected = YES;
        }
    }
}

- (void)changeProgress:(UISlider *)sender
{
    [self.musicManager seekTotimeWithValue:((UISlider *)sender).value];
}

- (void)showAlbum:(UIButton *)sender
{
    MusicInfoModel *model = _dataArray[_songsItem];
    if (!sender.selected) {
        [_MusicView.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(180);
        }];
        [_MusicView.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(180);
        }];
        _MusicView.labelcell.hidden = NO;
        _MusicView.labelcell.name.text = model.name;
        _MusicView.labelcell.singer.text = model.singer;
        NSString *title = model.name;
        if (title.length > 26) {
            NSString *newTitle = [title substringToIndex:26];
            _MusicView.labelcell.name.text = newTitle;
        }
        [_MusicView.albumView.albumImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
        [_MusicView.musicPicker selectRow:_songsItem inComponent:0 animated:YES];
        _MusicView.albumView.hidden = NO;
        _MusicView.albumView.alpha = 0;
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            _MusicView.musicPicker.alpha = 0;
            _MusicView.albumView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _MusicView.musicPicker.hidden = YES;
            sender.selected = YES;
        }];
    }else {
        [_MusicView.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-40);
        }];
        [_MusicView.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-40);
        }];
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            _MusicView.musicPicker.alpha = 1;
            _MusicView.albumView.alpha = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _MusicView.labelcell.hidden = YES;
            _MusicView.musicPicker.hidden = NO;
            _MusicView.albumView.hidden = YES;
            sender.selected = NO;
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 远程控制事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    NSLog(@"%li,%li",(long)event.type,(long)event.subtype);
    if(event.type==UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self Play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self Play];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self Next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self Last];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"Begin seek forward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"End seek forward...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"Begin seek backward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"End seek backward...");
                break;
            default:
                break;
        }
    }
}

- (void)localMusicViewDidTouchPlayButton:(UIButton *)playButton
{
    [self Play];
}
- (void)localMusicViewDidTouchNextButton:(UIButton *)nextButton
{
    [self Next];
}
- (void)localMusicViewDidTouchLastButton:(UIButton *)lastButton
{
    [self Last];
}
- (void)localMusicViewDidChangeProgress:(UISlider *)progress
{
    [self changeProgress:progress];
}
- (void)localMusicViewDidShowAlbum:(UIButton *)showAlbum
{
    [self showAlbum:showAlbum];
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
