//
//  UIImage+CutImage.h
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CutImage)

-(UIImage *)cutImageAtSquare:(UIImage*)image Frame:(CGRect)frame;

- (NSArray<UIImage *> *)cutImageWithRow:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
