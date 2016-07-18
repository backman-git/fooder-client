//
//  pickerResultController.h
//  fooderV2
//
//  Created by Backman on 2015/11/9.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@interface pickerResultController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>




@property (weak, nonatomic) IBOutlet UIImageView *foodImgView;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton;
@property (weak, nonatomic) IBOutlet UIImageView *segmentView;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;

@end
