//
//  PieceModel.h
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PieceModel : NSObject
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic) NSInteger imageID;
//用于自由拼图中判断位置是否正确
@property (nonatomic) CGRect finishRect;
@end

NS_ASSUME_NONNULL_END
