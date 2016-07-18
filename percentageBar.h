//
//  progressBar.h
//  fooderV2
//
//  Created by Backman on 2015/11/26.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface percentageBar : CAShapeLayer


@property  float percentage;
@property (strong, nonatomic) UIColor* color;
@property BOOL clockWise;

-(void) setPercentage:(float)percentage clockWise:(BOOL)cw color:(UIColor*)co;


@end
