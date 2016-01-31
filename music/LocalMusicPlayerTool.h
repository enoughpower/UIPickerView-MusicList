//
//  LocalMusicPlayerTool.h
//  music
//
//  Created by autobot on 16/1/27.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicInfoModel.h"
@protocol LocalMusicPlayerToolDelegate <NSObject>
// 播放进度
-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;
// 播放完成
-(void)MusicDidEndPlay;

@end

@interface LocalMusicPlayerTool : NSObject
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)MusicInfoModel * model;
@property(nonatomic,weak)id delegate;
// 构造方法
+(instancetype)shareMusicPlay;
// 准备播放，准备完毕自动播放
-(void)musicPrePlay;
// 恢复播放(用于恢复暂停播放)
-(void)musicPlay;
// 暂停播放
-(void)musicPause;
// 跳转播放进度
-(void)seekTotimeWithValue:(CGFloat)value;
// 返回歌词数组
-(NSMutableArray *)getLyricArray;
// 返回某句歌词在数组中的位置
-(NSInteger)getIndexFromArray;


@end
