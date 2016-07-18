//
//  FD.h
//  fooderV2
//
//  Created by Backman on 2015/12/9.
//  Copyright © 2015年 Backman. All rights reserved.
//
#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

@interface FD : NSObject{


    NSString* ID;
    UIImage* img;
    
    NSNumber* gValue;
    
    NSNumber* bValue;

    NSNumber* similarity;


}

@property (nonatomic,readwrite) NSString* ID;
@property (nonatomic,strong) UIImage* img;
@property (nonatomic,readwrite) NSNumber* gValue;
@property (nonatomic,readwrite) NSNumber* bValue;
@property (nonatomic,readwrite) NSNumber* similarity;
@end

