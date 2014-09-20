// GSProgressHUD.m
//
// Copyright (c) 2014 Gard Sandholt
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GSProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface GSProgressHUD ()

@property(nonatomic, strong) UIImageView *statusIcon;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)showType:(GSProgressHUDViewType)viewType;
- (void)dismiss;
- (void)popImage:(UIImage *)image withStatus:(NSString *)status;
- (void)showImage:(UIImage *)image withStatus:(NSString *)status;

- (void)setHUDSizesForViewType:(GSProgressHUDViewType)viewType;

@end

@implementation GSProgressHUD


#pragma mark -
#pragma mark Class methods

+ (GSProgressHUD *)sharedView {
    static GSProgressHUD *sharedView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[GSProgressHUD alloc] initWithFrame:CGRectMake(0.f, 0.f, kDefaultHUDWidth, kDefaultHUDHeight)];
        sharedView.currentHUDType = GSProgressHUDViewTypeIndicator;
    });
    return sharedView;
}

+ (void)popImage:(UIImage *)image withStatus:(NSString *)status {
    [[GSProgressHUD sharedView] popImage:image withStatus:status];
}

+ (void)showImage:(UIImage *)image withStatus:(NSString *)status {
    [[GSProgressHUD sharedView] showImage:image withStatus:status];
}

+ (void)show {
    [[GSProgressHUD sharedView] showType:GSProgressHUDViewTypeIndicator];
}

+ (void)dismiss {
    [[GSProgressHUD sharedView] dismiss];
}

+ (BOOL)isVisible {
    return ([GSProgressHUD sharedView].alpha == 1.f);
}


#pragma mark -
#pragma mark Instance methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 0.f;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.75f];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, 5.f);
        self.layer.shadowRadius = 10.f;
        self.layer.shadowOpacity = .7f;
    }
    
    return self;
}

- (void)showType:(GSProgressHUDViewType)viewType {
    if (!self.superview) {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    }
    
    // Clear previous added views
    if (self.statusIcon.superview) {
        [self.statusIcon removeFromSuperview];
    }
    if (self.statusLabel.superview) {
        [self.statusLabel removeFromSuperview];
    }
    if (self.activityView.superview) {
        [self.activityView removeFromSuperview];
    }
    
    // Set view type views
    switch (viewType) {
        case GSProgressHUDViewTypeIndicator:
            if (!self.activityView.superview) {
                [self addSubview:self.activityView];
            }
            break;
        case GSProgressHUDViewTypeIcon:
            if (!self.statusIcon.superview) {
                [self addSubview:self.statusIcon];
            }
            if (!self.statusLabel.superview) {
                [self addSubview:self.statusLabel];
            }
            break;
    }
    
    [self setHUDSizesForViewType:viewType];

    
    // Show view
    if (self.alpha != 1.f) {
        
        self.transform = CGAffineTransformScale(self.transform, .7f, .7f);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 1.f/.7f, 1.f/.7f);
                             self.alpha = 1.f;
                         } completion:nil];
    }
}

- (void)popImage:(UIImage *)image withStatus:(NSString *)status {
    [self showImage:image withStatus:status];
    
    double delayInSeconds = 0.55;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismiss];
    });
}

- (void)showImage:(UIImage *)image withStatus:(NSString *)status {
    
    self.statusIcon.image = image;
    self.statusLabel.text = status;
    
    if (![GSProgressHUD isVisible]) {
        [self showType:GSProgressHUDViewTypeIcon];
    }
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.3f, 1.3f);
                         self.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         self.transform = CGAffineTransformScale(self.transform, 1.f/1.3f, 1.f/1.3f);
                     }];
    
}


#pragma mark -
#pragma mark Size calculation

static CGFloat const kDefaultHUDWidth = 70.f;
static CGFloat const kDefaultHUDHeight = 66.f;
static CGFloat const kStatusFontOfSize = 12.f;
static CGFloat const kMargin = 10.f;
static CGFloat const kMarginBottom = 8.f;
static CGFloat const kMarginTop = 12.f;
static CGFloat const kGolden = 1.61803398875;

- (void)setHUDSizesForViewType:(GSProgressHUDViewType)viewType {
    CGRect backgroundRect = self.frame;
    
    switch (viewType) {
        case GSProgressHUDViewTypeIndicator:
            ;

            backgroundRect.size.width = kDefaultHUDWidth;
            backgroundRect.size.height = kDefaultHUDHeight;
            
            self.frame = backgroundRect;
            
            _activityView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
            break;
        case GSProgressHUDViewTypeIcon:
            ;

            // Calculate label size
            CGSize maxSize = CGSizeMake(300.f, MAXFLOAT);
            CGRect statusLabelRect = [self.statusLabel.text boundingRectWithSize:maxSize
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{
                                                                                   NSFontAttributeName:self.statusLabel.font
                                                                                   }
                                                                         context:nil];
            
            // Calculate background size
            CGFloat newBackgroundWidth = ((kDefaultHUDWidth - (kMargin * 2.f)) < statusLabelRect.size.width ? (statusLabelRect.size.width + (kMargin * 2.f)) : kDefaultHUDWidth);
            CGFloat newBackgroundHeight = (kDefaultHUDWidth == newBackgroundWidth ? newBackgroundWidth / kGolden : kDefaultHUDHeight);
            
            backgroundRect.size.width = newBackgroundWidth;
            backgroundRect.size.height = newBackgroundHeight;
            
            self.frame = backgroundRect;
            
            // Set label size
            self.statusLabel.frame = CGRectMake(kMargin, kDefaultHUDHeight - (statusLabelRect.size.height + kMarginBottom), statusLabelRect.size.width, statusLabelRect.size.height);
            
            // Calculate icon size
            CGFloat statusIconSize = (newBackgroundHeight / kGolden) / kGolden;
            self.statusIcon.frame = CGRectMake(15.f, kMarginTop, statusIconSize, statusIconSize);
            self.statusIcon.center = CGPointMake(self.statusLabel.center.x, self.statusIcon.center.y);
            
            break;
    }
    
    self.center = CGPointMake(self.superview.frame.size.width/2.f, self.superview.frame.size.height/2.f);
}

#pragma mark -
#pragma mark Properties methods

- (UIImageView *)statusIcon {
    if (!_statusIcon) {
        _statusIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _statusIcon.backgroundColor = [UIColor clearColor];
        _statusIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusIcon;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont boldSystemFontOfSize:kStatusFontOfSize];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
    }
    return _activityView;
}

@end
