//
//  ViewController.m
//  WTBannerScroll
//
//  Created by Tao Yun on 16/2/2.
//  Copyright © 2016年 taoYun. All rights reserved.
//

#import "ViewController.h"
#import "WTScrollView.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageArray = @[
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                            ];
    
    WTScrollView *scrollV = [WTScrollView initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 160) imgURLArray:imageArray placeHolderImage:@"pictureHolder" pageControlShowStyle:pageControlPositionStyleCenter];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scrollV.imgTapBlock = ^(NSInteger index, NSString *imageURL) {
        NSLog(@"点击了第 %ld 张",index);
    };
    [self.view addSubview:scrollV];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.view.center.y, self.view.frame.size.width - 30, 160)];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg"]];
    [self.view addSubview:imageView];
}

@end
