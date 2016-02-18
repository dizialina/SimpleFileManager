//
//  FileCell.h
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
