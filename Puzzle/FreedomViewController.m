//
//  FreedomViewController.m
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import "FreedomViewController.h"
#import "UIImage+CutImage.h"
#import "PieceModel.h"
#import "UIColor+Hex.h"
#import "Puzzle-Swift.h"

#define ScreenWidth             [UIScreen mainScreen].bounds.size.width
#define ScreenHeight            [UIScreen mainScreen].bounds.size.height

@interface FreedomViewController ()
@property (nonatomic, strong) NSMutableArray<PieceModel *> * models;
@property (nonatomic, strong) NSMutableArray * viewArray;;
@property (nonatomic, strong) UIView * gameView;

@property (nonatomic, strong) NSMutableArray * resultArray;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end

@implementation FreedomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _models = [[NSMutableArray alloc] initWithCapacity:_algorithm*_algorithm];
    _viewArray = [[NSMutableArray alloc] initWithCapacity:_algorithm*_algorithm];
    
    NSArray * images = [_gameImage cutImageWithRow:_algorithm];
    
    _resultArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    _width = ScreenWidth*0.5;
    _height = _width*10/17;
    
    int row = 0;
    CGFloat fixX = (_width/_algorithm-50)*0.5;
    CGFloat fixY = (_height/_algorithm-50)*0.5;
    for (int i=0; i < _algorithm*_algorithm; ++i) {
        _resultArray[i] = @(NO);
        int cow = (i+1) % _algorithm;
        CGRect rect = CGRectMake(50*cow+fixX*(2*cow+1)+_width, 50*row+fixY*(2*row+1), 50, 50);
        if (cow == 0) {
            row += 1;
        }
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
        model.finishRect = rect;
        [_models addObject:model];
    }
    
    [self createGameView];
}

- (void)createGameView {
    _gameView = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
    _gameView.backgroundColor = [UIColor colorWithCSS:@"ffaad5"];
    _gameView.layer.borderColor = [UIColor colorWithCSS:@"be77ff"].CGColor;
    _gameView.layer.borderWidth = 1;
    _gameView.clipsToBounds = YES;
    [self.view addSubview:_gameView];
    [self startGame];
    
    CGFloat imageVHeight = ScreenHeight-CGRectGetHeight(_gameView.frame)-10;
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _height+10, imageVHeight*1.7, imageVHeight)];
    imageV.image = _gameImage;
    [self.view addSubview:imageV];
    
    UIButton * start = [YSDButton createHSRedButtonWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+20, 0, 100, 44) Title:@"开始游戏" Action:^(YSDButton * but) {
        [self startGame];
    }];
    start.center = CGPointMake(start.center.x, imageV.center.y);
    [self.view addSubview:start];
    
    UIButton * restart = [YSDButton createHSRedButtonWithFrame:CGRectMake(CGRectGetMaxX(start.frame)+20, 0, 100, 44) Title:@"重新选择" Action:^(YSDButton * but) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    restart.center = CGPointMake(restart.center.x, imageV.center.y);
    [self.view addSubview:restart];
}

- (void)startGame {
    CGFloat y = 0;
    [_models sortUsingComparator:^NSComparisonResult(PieceModel *  _Nonnull obj1, PieceModel *  _Nonnull obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return obj1.imageID < obj2.imageID;
        } else {
            return obj1.imageID > obj2.imageID;
        }
    }];
    int row = 0;
    CGFloat pieceWidth = _width/_algorithm;
    CGFloat pieceHeight = _height/_algorithm;
    for (int i=0; i < _algorithm*_algorithm; ++i) {
        int cow = (i+1) % _algorithm;
        CGRect rectImage = CGRectMake(pieceWidth*cow, pieceHeight*row+y, pieceWidth, pieceHeight);
        if (cow == 0) {
            row += 1;
        }
        
        PieceModel * model = _models[i];
        model.imageView.frame = rectImage;
        model.imageView.tag = i;
        [self.view addSubview:model.imageView];
    }
}

#pragma mark 改变位置
-(void)locationChange:(UIPanGestureRecognizer*)pan {
    [self.view bringSubviewToFront:pan.view];

    CGPoint point = [pan translationInView:self.view.superview];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view.superview];
    PieceModel * model;
    int index = 0;
    if(pan.state == UIGestureRecognizerStateEnded){
        for (int i=0; i<_models.count; ++i) {
            UIImageView * v = _models[i].imageView;
            if (pan.view == v) {
                model = _models[i];
                index = i;
                break;
            }
        }
        [self changeView:pan.view.center and:model and:index];
    }
}

- (void)changeView:(CGPoint)point and:(PieceModel *)model and:(int)index {
    if (CGRectContainsPoint(model.finishRect, point)) {
        _resultArray[index] = @(YES);
    }
    BOOL finish = YES;
    for (NSNumber * m in _resultArray) {
        if (![m boolValue]) {
            finish = NO;
            break;
        }
    }
    if (finish) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"拼图完成！！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
