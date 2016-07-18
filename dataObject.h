//
//  dataObject.h
//  fooderV2
//
//  Created by Backman on 2015/11/17.
//  Copyright © 2015年 Backman. All rights reserved.
//

#ifndef dataObject_h
#define dataObject_h
#import <UIKit/UIKit.h>





@interface dataObject : NSObject {
    
    //RS
    UIImage* imgRS;
    NSNumber* resultID_RS;
    NSMutableDictionary* ansRS;
    
    
    
    
    
    
    
    //fooder
    
    
    UIImage* imgFD;
    NSMutableDictionary* ansFooders;
    NSString* RSID_of_FD;
    NSNumber* resultID_FD;
    
    
    
    
    
    
    
}

//RS
@property (strong, nonatomic)  UIImage *imgRS;
@property (strong, nonatomic)  NSNumber* resultID_RS;

@property (strong, nonatomic)  NSMutableDictionary* ansRS;


//FD
@property (strong, nonatomic)  UIImage *imgFD;
@property (strong, nonatomic)  NSString* RSID_of_FD;

@property (strong, nonatomic)  NSMutableDictionary* ansFooders;
@property (strong, nonatomic)  NSNumber* resultID_FD;

+(dataObject*)getInstance;

@end








#endif /* dataObject_h */
