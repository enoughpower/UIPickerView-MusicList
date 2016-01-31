//
//  LocalMusicPickViewCell.m
//  music
//
//  Created by autobot on 16/1/25.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicPickViewCell.h"
#import "Masonry.h"
@implementation LocalMusicPickViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _name.font = [UIFont systemFontOfSize:15.f];
        _name.textColor = [UIColor whiteColor];
        _name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_name];
        _singer = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 15)];
        _singer.font = [UIFont systemFontOfSize:12.f];
        _singer.textAlignment = NSTextAlignmentCenter;
        _singer.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:_singer];

        
    }
    return self;
}

@end
