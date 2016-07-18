//
//  TableViewCell.h
//  fooderV2
//
//  Created by Backman on 2015/11/16.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *outline;
@property (weak, nonatomic) IBOutlet UIImageView *foodView;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;

@property (weak, nonatomic) IBOutlet UILabel *similarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UIButton *thumbUp;
@property (weak, nonatomic) IBOutlet UIButton *thumbDown;


@end
