//
//  NKArrowView.m
//  ArrowViewTest
//
//  Created by Nick on 2017/3/9.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKArrowView.h"

@implementation NKArrowView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect frame = rect;
    frame.size.height = frame.size.height;
    rect = frame;
    //绘制带箭头的框框
    [self drawArrowRectangle:rect];
}

//绘制带箭头的矩形
-(void)drawArrowRectangle:(CGRect) frame
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, COLOR_BORDER_GRAY.CGColor);
    CGContextMoveToPoint(context, frame.origin.x, frame.origin.y + 5);
    CGContextAddLineToPoint(context, self.arrow_x - 3, frame.origin.y + 5);
    CGContextAddLineToPoint(context, self.arrow_x, frame.origin.y + 5 - 3);
    CGContextAddLineToPoint(context, self.arrow_x + 3, frame.origin.y + 5);
    CGContextAddLineToPoint(context, frame.size.width, frame.origin.y + 5);
    CGContextStrokePath(context);
}

@end
