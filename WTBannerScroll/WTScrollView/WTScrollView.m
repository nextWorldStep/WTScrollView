//
//  WTScrollView.m
//  WTBannerScroll
//
//  Created by Tao Yun on 16/2/2.
//  Copyright © 2016年 taoYun. All rights reserved.
//

#import "WTScrollView.h"
#import "UIImageView+WebCache.h"

@interface WTPageControl : UIPageControl

/**
 *  当前轮播到的imageview
 */

@property (nonatomic, strong) UIImage *selectImage;

/**
 *  未轮播到的imageview
 */

@property (nonatomic, weak) UIImage *unSelectImage;

@end

@interface WTScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScroll;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) NSInteger leftImageIndex;
@property (nonatomic, assign) NSInteger rightImageIndex;
@property (nonatomic, assign) NSInteger centerImageIndex;

@property (strong, nonatomic) UIImage *placeHolderImage;
@property (strong, nonatomic) NSArray *imageURLArray;

@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) BOOL isTimeUp;
@property (nonatomic, strong) WTPageControl *wtPageControl;

@end

@implementation WTScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _scrollTimer = 3.0;
        _isScrollEnable = YES;
        
        _mainScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScroll.backgroundColor = [UIColor whiteColor];
        _mainScroll.bounces = NO;
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.pagingEnabled = YES;
        _mainScroll.contentOffset = CGPointMake(CGRectGetWidth(_mainScroll.frame), 0);
        _mainScroll.contentSize = CGSizeMake(CGRectGetWidth(_mainScroll.frame) * 3, CGRectGetHeight(_mainScroll.frame));
        _mainScroll.delegate = self;
        _mainScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //        左
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mainScroll.frame), CGRectGetHeight(_mainScroll.frame))];
        [_mainScroll addSubview:_leftImageView];
        //        中
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_mainScroll.frame), 0, CGRectGetWidth(_mainScroll.frame), CGRectGetHeight(_mainScroll.frame))];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)]];
        [_mainScroll addSubview:_centerImageView];
        //        右
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_mainScroll.frame) * 2, 0, CGRectGetWidth(_mainScroll.frame), CGRectGetHeight(_mainScroll.frame))];
        [_mainScroll addSubview:_rightImageView];
        
        [self addSubview:_mainScroll];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self startTimer];
    }
}

- (void)startTimer {
    if (_isScrollEnable && _imageURLArray.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimer target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
    }
}

- (void)scrollImage {
    [_mainScroll setContentOffset:CGPointMake(CGRectGetWidth(_mainScroll.frame) * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:YES];
}

#pragma mark --- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_mainScroll.contentOffset.x == 0) {
        _centerImageIndex = _centerImageIndex - 1;
        _leftImageIndex = _leftImageIndex - 1;
        _rightImageIndex = _rightImageIndex - 1;
        
        if (_leftImageIndex == -1) _leftImageIndex = _imageURLArray.count - 1;
        if (_centerImageIndex == -1) _centerImageIndex = _imageURLArray.count - 1;
        if (_rightImageIndex == -1) _rightImageIndex = _imageURLArray.count - 1;
        
    } else if(_mainScroll.contentOffset.x == CGRectGetWidth(_mainScroll.frame) * 2) {
        _centerImageIndex = _centerImageIndex + 1;
        _leftImageIndex = _leftImageIndex + 1;
        _rightImageIndex = _rightImageIndex + 1;
        
        if (_leftImageIndex == _imageURLArray.count) _leftImageIndex = 0;
        if (_centerImageIndex == _imageURLArray.count) _centerImageIndex = 0;
        if (_rightImageIndex == _imageURLArray.count) _rightImageIndex = 0;
        
    } else {
        return;
    }
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[_leftImageIndex]] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[_centerImageIndex]] placeholderImage:_placeHolderImage];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[_rightImageIndex]] placeholderImage:_placeHolderImage];
    
    _wtPageControl.currentPage = _centerImageIndex;
    
    _mainScroll.contentOffset = CGPointMake(CGRectGetWidth(_mainScroll.frame), 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTimer]];
    }
    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)tapImageView {
    if (_imgTapBlock) {
        _imgTapBlock(_centerImageIndex, _imageURLArray[_centerImageIndex]);
    }
}


+(instancetype)initWithFrame:(CGRect)frame imgURLArray:(NSArray *)imgURLArray placeHolderImage:(NSString *)placeHolderImageName pageControlShowStyle:(pageControlPositionStyle)pageControlShowStyle {
    WTScrollView *wtScrollView = [[WTScrollView alloc] initWithFrame:frame];
    wtScrollView.placeHolderImage = [UIImage imageNamed:placeHolderImageName];
    [wtScrollView addImageWithArray:imgURLArray];
    [wtScrollView addPageControlWithStyle:pageControlShowStyle];
    return wtScrollView;
}

-(void)addImageWithArray:(NSArray *)imageArray {
    _imageURLArray = imageArray;
    if (imageArray.count == 0) {
        return;
    }
    
    _leftImageIndex = imageArray.count - 1;
    _centerImageIndex = 0;
    _rightImageIndex = 1;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[_leftImageIndex]] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[_centerImageIndex] ] placeholderImage:_placeHolderImage];
    if (imageArray.count < 2) {
        _mainScroll.scrollEnabled = NO;
        return;
    }
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[_rightImageIndex] ] placeholderImage:_placeHolderImage];
}

- (void)addPageControlWithStyle:(pageControlPositionStyle)pageControlShowStyle {
    if (pageControlShowStyle == pageControlPositionStyleDefault || _imageURLArray.count < 2) {
        return;
    }
    _wtPageControl = [[WTPageControl alloc] init];
    _wtPageControl.numberOfPages = _imageURLArray.count;
    
    switch (pageControlShowStyle) {
        case pageControlPositionStyleBottomLeft:
            _wtPageControl.frame = CGRectMake(0, CGRectGetHeight(_mainScroll.frame) - 20, 20 * _wtPageControl.numberOfPages, 20);
            break;
        case pageControlPositionStyleCenter:
            _wtPageControl.center = CGPointMake(_mainScroll.center.x, CGRectGetHeight(_mainScroll.frame) - 20);
            _wtPageControl.bounds = CGRectMake(0, 0, 20 * _wtPageControl.numberOfPages, 20);
            break;
        case pageControlPositionStyleBottomRight:
            _wtPageControl.frame = CGRectMake(CGRectGetWidth(_mainScroll.frame) - 20 * _wtPageControl.numberOfPages, CGRectGetHeight(_mainScroll.frame) - 40, 20 * _wtPageControl.numberOfPages, 20);
            break;
        case pageControlPositionStyleTopLeft:
            _wtPageControl.frame = CGRectMake(0, 0, 20 * _wtPageControl.numberOfPages, 20);
            break;
        case pageControlPositionStyleTopRight:
            _wtPageControl.frame = CGRectMake(CGRectGetWidth(_mainScroll.frame) - 20 * _wtPageControl.numberOfPages, 0, 20 * _wtPageControl.numberOfPages, 20);
            break;
            
        default:
            break;
    }
    
    _wtPageControl.currentPage = 0;
    _wtPageControl.enabled = NO;
    [self addSubview:_wtPageControl];
}

@end

@implementation WTPageControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectImage = [UIImage imageNamed:@"all_yellow_circle"];
        self.unSelectImage = [UIImage imageNamed:@"border_yellow_circle"];
    }
    return self;
}
- (void)updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.subviews[i].bounds];
        [self.subviews[i] addSubview:imageV];
    }
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *imagev = (UIImageView *)self.subviews[i].subviews[0];
        if ([imagev isKindOfClass:[UIImageView class]]) {
            if (i == self.currentPage) {
                imagev.image = _selectImage;
            } else {
                imagev.image = _unSelectImage;
            }
        }
    }
}
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end

