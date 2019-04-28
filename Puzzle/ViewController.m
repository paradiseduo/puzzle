//
//  ViewController.m
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+CutImage.h"
#import "PieceModel.h"
#import "UIColor+Hex.h"
#import "Puzzle-Swift.h"

#define ScreenWidth             [UIScreen mainScreen].bounds.size.width
#define ScreenHeight            [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<PieceModel *> * models;
@property (nonatomic, strong) NSMutableArray * viewArray;;
@property (nonatomic, strong) UIView * gameView;

@property (strong, nonatomic) UIView * tempBottom;
@property (assign, nonatomic) NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _models = [[NSMutableArray alloc] initWithCapacity:_algorithm*_algorithm];
    _viewArray = [[NSMutableArray alloc] initWithCapacity:_algorithm*_algorithm];
    
    NSArray * images = [_gameImage cutImageWithRow:_algorithm];
    
    for (int i=0; i < _algorithm*_algorithm; ++i) {
        UIImageView * imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = YES;
        imageV.image = images[i];
        imageV.layer.borderWidth = 1;
        imageV.layer.borderColor = [UIColor colorWithCSS:@"be77ff"].CGColor;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [imageV addGestureRecognizer:pan];
        PieceModel * model = [[PieceModel alloc] init];
        model.imageID = i;
        model.imageView = imageV;
        [_models addObject:model];
    }
    
    [self createGameView];
}

- (void)createGameView {
    CGFloat x = ScreenWidth*0.25;
    CGFloat width = ScreenWidth-x;
    CGFloat height = width*10/17;
    CGFloat y = 0;
    _gameView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _gameView.backgroundColor = [UIColor colorWithCSS:@"ffaad5"];
    _gameView.layer.borderColor = [UIColor colorWithCSS:@"be77ff"].CGColor;
    _gameView.layer.borderWidth = 1;
    _gameView.clipsToBounds = YES;
    [self.view addSubview:_gameView];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, x, x*10/17)];
    imageV.image = _gameImage;
    [self.view addSubview:imageV];
    
    UIButton * start = [YSDButton createHSRedButtonWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+20, 100, 44) Title:@"开始游戏" Action:^(YSDButton * but) {
        [self startGame];
    }];
    start.center = CGPointMake(imageV.center.x, start.center.y);
    [self.view addSubview:start];
    
    UIButton * restart = [YSDButton createHSRedButtonWithFrame:CGRectMake(0, CGRectGetMaxY(start.frame)+20, 100, 44) Title:@"重新选择" Action:^(YSDButton * but) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    restart.center = CGPointMake(imageV.center.x, restart.center.y);
    [self.view addSubview:restart];
}

- (void)startGame {
    for (UIView * v in _gameView.subviews) {
        [v removeFromSuperview];
    }
    [_models sortUsingComparator:^NSComparisonResult(PieceModel *  _Nonnull obj1, PieceModel *  _Nonnull obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return obj1.imageID < obj2.imageID;
        } else {
            return obj1.imageID > obj2.imageID;
        }
    }];
    int row = 0;
    CGFloat pieceWidth = CGRectGetWidth(_gameView.frame)/_algorithm;
    CGFloat pieceHeight = CGRectGetHeight(_gameView.frame)/_algorithm;
    for (int i=0; i < _algorithm*_algorithm; ++i) {
        int cow = (i+1) % _algorithm;
        CGRect rect = CGRectMake(pieceWidth*cow, pieceHeight*row, pieceWidth, pieceHeight);
        if (cow == 0) {
            row += 1;
        }
        
        UIView * v = [[UIView alloc] initWithFrame:rect];
        v.backgroundColor = [UIColor clearColor];
        v.tag = i+100;
        [_viewArray addObject:v];
        [_gameView addSubview:v];
        
        PieceModel * model = _models[i];
        model.imageView.frame = rect;
        model.imageView.tag = i;
        [_gameView addSubview:model.imageView];
    }
}

#pragma mark 改变位置
-(void)locationChange:(UIPanGestureRecognizer*)pan {
    
    [_gameView bringSubviewToFront:pan.view];
    
    CGPoint point = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    PieceModel * model;
    if(pan.state == UIGestureRecognizerStateEnded){
        for (int i=0; i<_models.count; ++i) {
            UIImageView * v = _models[i].imageView;
            if (pan.view == v) {
                self.tempBottom = [_viewArray objectAtIndex:i];
                self.index = i;
                model = _models[i];
                break;
            }
        }
        [self changeView:pan.view.center and:model];
    }
}

- (void)changeView:(CGPoint)point and:(PieceModel *)model {
    BOOL reset = YES;
    for (int i=0; i<_viewArray.count; ++i) {
        UIView * currentBottom = _viewArray[i];
        if(point.x > currentBottom.frame.origin.x  && point.x < currentBottom.frame.size.width+currentBottom.frame.origin.x){
            if(point.y > currentBottom.frame.origin.y && point.y < currentBottom.frame.size.height+currentBottom.frame.origin.y){
                PieceModel * current = _models[i];
                [_models exchangeObjectAtIndex:i withObjectAtIndex:self.index];
                reset = NO;
                [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    model.imageView.frame = currentBottom.frame;
                    current.imageView.frame = self.tempBottom.frame;
                } completion:^(BOOL finished) {
                    [self.gameView bringSubviewToFront:model.imageView];
                    [self.gameView bringSubviewToFront:current.imageView];
                    
                    BOOL finish = YES;
                    for (int i=0; i<self.models.count; ++i) {
                        if (self.models[i].imageID != i) {
                            finish = NO;
                            break;
                        }
                    }
                    if (finish) {
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"拼图完成！！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
                break;
            }
        }
    }
    
    if(reset){
        [UIView animateWithDuration:0.25 animations:^{
            model.imageView.center = self.tempBottom.center;
        } completion:nil];
    }
}

@end
