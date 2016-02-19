//
//  ImageController.m
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "ImageController.h"

@interface ImageController ()

@end

@implementation ImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
    NSArray *barButtonsArray = [NSArray arrayWithObjects:homeButton, nil];
    self.navigationItem.rightBarButtonItems = barButtonsArray;
    
    self.navigationItem.title = self.fileName;
    
    self.fileImage.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageWithContentsOfFile:self.filePath];
    [self.fileImage setImage:image];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) backToRoot:(UIBarButtonItem*)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
