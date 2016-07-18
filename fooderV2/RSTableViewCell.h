//
//  RSTableViewCell.h
//  fooderV2
//
//  Created by Backman on 2015/12/6.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRS;
@property (weak, nonatomic) IBOutlet UILabel *similarityLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
