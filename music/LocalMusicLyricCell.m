//
//  LocalMusicLyricCell.m
//  music
//
//  Created by enoughpower on 16/1/31.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicLyricCell.h"
#import "Masonry.h"
@interface LocalMusicLyricCell ()
@property (nonatomic, strong)UILabel *lyricLabel;
@end

@implementation LocalMusicLyricCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _lyricLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _lyricLabel.textColor = [UIColor whiteColor];
        _lyricLabel.numberOfLines = 0;
        _lyricLabel.font = [UIFont systemFontOfSize:13.f];
        _lyricLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lyricLabel];
        [_lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        
    }
    return self;
}

- (void)setLyric:(NSString *)lyric
{
    _lyric = lyric;
    _lyricLabel.text = _lyric;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _lyricLabel.textColor = [UIColor colorWithRed:0/255.0 green:184/255.0 blue:235/255.0 alpha:1];
    }else {
        _lyricLabel.textColor = [UIColor whiteColor];
    }
    
    // Configure the view for the selected state
}

@end
