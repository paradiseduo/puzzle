//
//  UIImage+CutImage.m
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import "UIImage+CutImage.h"

@implementation UIImage (CutImage)

-(UIImage *)cutImageAtSquare:(UIImage*)image Frame:(CGRect)frame {
    UIImage* piePic=nil;
    if (self) {
        //获取截取区域大小
        CGSize sz=frame.size;
        //获取截取区域坐标
        CGPoint origin=frame.origin;
        //创建sz大小的上下文，背景是否透明：NO，缩放尺寸：0表示不缩放
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
        //移动坐标原点绘制图片，由于上下文坐标系与图片自身坐标系是相反的，所以绘制坐标需要取反
        [image drawAtPoint:CGPointMake(-origin.x, -origin.y)];
        //获取绘制后的图片
        piePic=UIGraphicsGetImageFromCurrentImageContext();
        //绘制结束
        UIGraphicsEndImageContext();
    }
    return piePic;
}

- (NSArray<UIImage *> *)cutImageWithRow:(NSInteger)count {
    CGSize imageSize = self.size;
    CGSize size = CGSizeMake(imageSize.width/count, imageSize.height/count);
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithCapacity:count*count];
    int row = 0;
    for (int i = 0; i<count*count; ++i) {
        int cow = (i+1) % count;
        CGRect cutRect = CGRectMake(size.width*cow, size.height*row, size.width, size.height);
        if (cow == 0) {
            row += 1;
        }
        UIImage * image = [self cutImageAtSquare:self Frame:cutRect];
        [imageArray addObject:image];
    }
    return imageArray;
}
@end
