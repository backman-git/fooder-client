//
//  percentageBar.m
//  fooderV2
//
//  Created by Backman on 2015/11/26.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import "percentageBar.h"


@implementation percentageBar

@synthesize percentage=_percentage,color=_color, clockWise=_clockWise;


-(void) setPercentage:(float)percentage clockWise:(BOOL)cw color:(UIColor*)co{

   
    _percentage=percentage;
    _clockWise=cw;
    _color=co;
    
    self.strokeColor = _color.CGColor;
    
    //percentage bar
    float dir;
    if(_clockWise==NO){
        dir=-1.0;
    }
    else{
        dir=1.0;
    }
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(160, 125) radius:100
                startAngle:-1*M_PI/2 endAngle:-1*M_PI/2+_percentage*2*M_PI*dir
                 clockwise:_clockWise];
    self.path = path.CGPath;
    
    

}




- (id)init
{
    if ((self = [super init]))
    {
        
        self.frame = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
        
        self.backgroundColor = [UIColor clearColor].CGColor;
        
        
       
        
        
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineWidth = 5;
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        

        
        
        
        
        
    }
    return self;
}







@end
