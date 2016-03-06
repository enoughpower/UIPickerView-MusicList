//
//  LocalMusicAlbumLyricView.m
//  music
//
//  Created by enoughpower on 16/1/31.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicAlbumLyricView.h"
#import "Masonry.h"
#import "LocalMusicLyricCell.h"
#import "MusicLyricModel.h"
static NSString *CellReuseIdentifier = @"lyricCell";
@interface LocalMusicAlbumLyricView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UIScrollView *bgView;
@end


@implementation LocalMusicAlbumLyricView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUi];
        [self initData];
    }
    return self;
}

- (void)initUi
{
    _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgView.contentSize = CGSizeMake(self.frame.size.width *2, self.frame.size.height);
    _bgView.showsHorizontalScrollIndicator = NO;
    _bgView.pagingEnabled = YES;
    [self addSubview:_bgView];
    
    UILabel *bgImage = [[UILabel alloc]initWithFrame:CGRectZero];
    bgImage.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    bgImage.layer.cornerRadius = 160;
    bgImage.layer.masksToBounds = YES;
    [_bgView addSubview:bgImage];
    
    _albumImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _albumImage.layer.masksToBounds = YES;
    _albumImage.layer.cornerRadius = 150;
    [_bgView addSubview:_albumImage];
    
    _lyricTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_lyricTable registerClass:[LocalMusicLyricCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _lyricTable.backgroundColor = [UIColor clearColor];
    [_lyricTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _lyricTable.showsVerticalScrollIndicator = NO;
    [_bgView addSubview:_lyricTable];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(55/2);
        make.width.and.height.equalTo(@(self.frame.size.width - 55));
        make.centerY.equalTo(_bgView);
    }];
    [_albumImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(75/2);
        make.width.and.height.equalTo(@(self.frame.size.width - 75));
        make.centerY.equalTo(_bgView);
    }];
    [_lyricTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(self.frame.size.width);
        make.width.equalTo(_bgView);
        make.height.equalTo(_bgView);
        make.top.equalTo(_bgView);
    }];
    
    
}

- (void)initData
{
    _lyrics = [NSMutableArray array];
    _lyricTable.delegate = self;
    _lyricTable.dataSource = self;
    
}

- (void)setLyrics:(NSMutableArray *)lyrics
{
    _lyrics = lyrics;
    [self.lyricTable reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.lyricTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalMusicLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    MusicLyricModel *model = _lyrics[indexPath.row];
    cell.lyric = model.lyricStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lyrics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
