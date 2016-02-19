//
//  ImageController.h
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageController : UIViewController

@property (strong, nonatomic) NSString* fileName;
@property (strong, nonatomic) NSString* filePath;

@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

@end
