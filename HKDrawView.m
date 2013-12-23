//
//  CEDrawView.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKDrawView.h"

typedef NS_ENUM(NSUInteger, StateType) {
    StateTypeDefault = 0,
    StateTypeMine,
    StateTypeNumber,
    StateTypeEmpty,
};

@implementation HKDrawView

- (CGSize)resize {
    CGRect newFrame = CGRectMake(0, 0, self.sideLength * self.columnCount , self.sideLength * self.rowCount);
    [self setFrame:newFrame];
    [self setNeedsDisplay];
    return newFrame.size;
}

- (void)drawSquare:(CGRect)bounds state:(StateType)state {
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:bounds];
    [[UIColor blackColor] setStroke];
    switch (state) {
        default:
        case StateTypeDefault:
            [[UIColor lightGrayColor] setFill];
            break;
        case StateTypeMine:
            [[UIColor redColor] setFill];
            break;
        case StateTypeNumber:
            [[UIColor greenColor] setFill];
            break;
        case StateTypeEmpty:
            [[UIColor whiteColor] setFill];
            break;
    }
    [rectanglePath fill];
    [rectanglePath stroke];
}

-(void)drawAllSquares {
    int i,j;
    for (i = 0; i < self.rowCount; i++) {
        for (j = 0; j < self.columnCount; j++) {
            [self drawSquare:CGRectMake(self.sideLength * j,self.sideLength * i, self.sideLength, self.sideLength)
                       state:rand()%4];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    if (CGSizeEqualToSize(CGSizeMake(self.sideLength, self.sideLength), rect.size)) {
        [self drawSquare:rect state:rand()%4];
    }
    else {
        [self drawAllSquares];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] > 0) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self];
        CGFloat rIdx = floor(location.x / self.sideLength);
        CGFloat cIdx = floor(location.y / self.sideLength);

        if (rIdx >= 0 && rIdx < self.rowCount && cIdx >= 0 && cIdx < self.columnCount) {
            //修改对应格子属性
            [self setNeedsDisplayInRect:CGRectMake(self.sideLength * rIdx, self.sideLength * cIdx, self.sideLength, self.sideLength)];
        }
    }
}

@end
