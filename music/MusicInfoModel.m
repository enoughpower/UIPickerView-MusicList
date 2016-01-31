//
//  MusicInfoModel.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel

// 重写的kvc部分方法.
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"lyric"]) {
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    }
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"duration"]) {
        self.duration = [NSString stringWithFormat:@"%@",value];
    }
}

@end
