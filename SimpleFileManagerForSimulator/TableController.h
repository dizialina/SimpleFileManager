//
//  ViewController.h
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 10.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCell.h"

@interface TableController : UITableViewController

@property (strong, nonatomic) NSString* path;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* homeButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)homeButtonAction:(id)sender;



@end

