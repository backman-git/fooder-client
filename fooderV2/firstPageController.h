//
//  firstPageController.h
//  fooderV2
//
//  Created by Backman on 2015/11/6.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataObject.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>




@interface firstPageController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    dataObject * dObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *mPImage;
@property (weak, nonatomic) IBOutlet UIButton *slideToSnap;

@end
