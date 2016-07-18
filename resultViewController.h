//
//  resultViewController.h
//  fooderV2
//
//  Created by Backman on 2015/11/16.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "percentageBar.h"
@interface resultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;

@property (weak, nonatomic) IBOutlet UIImageView *greenBackground;

@property (weak, nonatomic) IBOutlet UIImageView *redBackground;

@property (weak, nonatomic) IBOutlet UIImageView *greenCycleS;

@property (weak, nonatomic) IBOutlet UIImageView *redCycleS;

@property (strong, nonatomic) IBOutlet percentageBar *redBar;

@property (strong, nonatomic) IBOutlet percentageBar *greenBar;

@end
