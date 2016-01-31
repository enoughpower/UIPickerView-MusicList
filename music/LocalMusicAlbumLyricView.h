//
//  LocalMusicAlbumLyricView.h
//  music
//
//  Created by enoughpower on 16/1/31.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LocalMusicAlbumLyricView : UIView
@property (nonatomic, strong)UIImageView *albumImage;
@property (nonatomic, strong)UITableView *lyricTable;
@property (nonatomic, strong)NSMutableArray *lyrics;
@end
