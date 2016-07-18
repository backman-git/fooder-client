//
//  RSViewController.h
//  fooderV2
//
//  Created by Backman on 2015/12/6.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultRSViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewRS;

@end
