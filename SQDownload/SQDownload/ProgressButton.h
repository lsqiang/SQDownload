//
//  ProgressButton.h
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressButton : UIButton

@property (assign, nonatomic) IBInspectable float progress;
@property (strong, nonatomic) IBInspectable UIColor *lineColor;
@property (assign, nonatomic) IBInspectable CGFloat lineWidth;

@end
