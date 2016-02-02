//
//  WTScrollView.h
//  WTBannerScroll
//
//  Created by Tao Yun on 16/2/2.
//  Copyright © 2016年 taoYun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, pageControlPositionStyle) {
    pageControlPositionStyleDefault     = 0,
    pageControlPositionStyleBottomLeft  = 1,
    pageControlPositionStyleCenter      = 2,
    pageControlPositionStyleBottomRight = 3,
    pageControlPositionStyleTopLeft     = 4,
    pageControlPositionStyleTopRight    = 5
};

typedef void(^tapCallBackBlock) (NSInteger index, NSString *imgURL);

@interface WTScrollView : UIView

/**
 *  是否允许自动滑动
 */
@property (nonatomic, assign) BOOL isScrollEnable;

/**
 *  设置滑动间隔时间
 */
@property (nonatomic, assign) NSTimeInterval scrollTimer;

/**
 *  pageControl的位置
 */
@property (nonatomic, assign) pageControlPositionStyle pageControlShowStyle;

/**
 *  点击图片后的回调block
 */
@property (nonatomic, copy) tapCallBackBlock imgTapBlock;

+(instancetype)initWithFrame:(CGRect)frame imgURLArray:(NSArray *)imgURLArray placeHolderImage:(NSString *)placeHolderImageName pageControlShowStyle:(pageControlPositionStyle)pageControlShowStyle;

@end
