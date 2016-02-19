//
//  LocalMusicPlayerTool.m
//  music
//
//  Created by autobot on 16/1/27.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicPlayerTool.h"
#import "MusicLyricModel.h"

@interface LocalMusicPlayerTool ()
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation LocalMusicPlayerTool
+(instancetype)shareMusicPlay
{
    static LocalMusicPlayerTool * mp = nil;
    if (mp == nil) {
        static dispatch_once_t token ;
        dispatch_once(&token, ^{
            mp = [[LocalMusicPlayerTool alloc]init];
        });
    }
    return mp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

-(void)endOfPlay:(NSNotification *)sender
{
    [self  musicPause];
    if ([self.delegate respondsToSelector:@selector(MusicDidEndPlay)]) {
        [self.delegate MusicDidEndPlay];
    }
}
// 准备播放
-(void)musicPrePlay
{
    if (self.player.currentItem != nil) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    NSString *urlStr = self.model.mp3Url;
    NSURL *url = [NSURL URLWithString:urlStr];
    AVPlayerItem * item = [[AVPlayerItem alloc ]initWithURL:url];
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
}

// 观察者的处理方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"不知道什么错误");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"准备失败");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备成功, 开始播放...");
                [self musicPlay];
                break;
            default:
                break;
        }
    }
}

// 开始播放
-(void)musicPlay
{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [self.player play];
}

-(void)timerAction:(NSTimer *)sender
{
    if ([self.delegate respondsToSelector:@selector(getCurTiem:Totle:Progress:)]) {
            [self.delegate getCurTiem:[self intToString:[self getCurTime]] Totle:[self intToString:[self getTotleTime]] Progress:[self getProgress]];
    }
}

-(NSString * )intToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60, value%60];
}

// 暂停播放
-(void)musicPause
{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
}

// 播放跳转
-(void)seekTotimeWithValue:(CGFloat)value;
{
    // 先暂停
    [self musicPause];
    
    // 跳转
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self musicPlay];
        }
    }];
}

// 获取当前歌曲总时长
-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else{
        return totleTime.value / totleTime.timescale;
    }
}

// 获取当前播放时间
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
}

// 当前播放进度(0-1)
-(CGFloat)getProgress
{
    // 当前播放时间 / 播放总时间, 得到一个0-1的进度百分比即可.
    // 注意类型, 两个整型做除, 得到仍是整型. 所以要强转一下.
    return (CGFloat)[self getCurTime] / (CGFloat)[self getTotleTime];

// 获取歌词数组
// 让当前播放器单例类根据自己正在播放的model, 产生一个数组, 这个数组可以被外界直接拿到. 再去布局.
}
-(NSMutableArray *)getLyricArray
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * str in self.model.timeLyric) {
        MusicLyricModel * model = [[MusicLyricModel alloc] init];
        NSString * string1 = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
        model.lyricTime = [[string1 componentsSeparatedByString:@"]"] firstObject];
        model.lyricStr = [[string1 componentsSeparatedByString:@"]"] lastObject];
        
        [array addObject:model];
    }
    return array;
}
// 根据当前的播放时间, 遍历整个歌词数组, 一旦发现歌词数组中有和当前播放时间一致的秒数, 则立刻返回该条歌词在数组中的位置.
// 之后, 由播放界面控制器将歌词tableView跳转到该行即可.
-(NSInteger)getIndexFromArray
{
    NSInteger index = 0;
    NSString * curTime = [self intToString:[self getCurTime]];
    
    for (NSString * str  in self.model.timeLyric) {
        if (str.length == 0) {
            continue;
        }
        if ([curTime isEqualToString:[str substringWithRange:NSMakeRange(1, 5)]]) {
            return index;
        }
        index ++;
    }
    return -1;
}





@end
