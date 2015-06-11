//
//  ProgressButton.m
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import "ProgressButton.h"

@implementation ProgressButton

- (void)setProgress:(float)progress {
    
    _progress = progress;
    
    [self setTitle:[NSString stringWithFormat:@"%.02f%%", progress*100] forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGPoint center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = MIN(rect.size.width*0.5, rect.size.height*0.5) - self.lineWidth;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2*M_PI * self.progress + startAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.lineColor setStroke];
    [path setLineWidth:self.lineWidth];
    [path setLineCapStyle:kCGLineCapRound];
    
    [path stroke];
}

@end
