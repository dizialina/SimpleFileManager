//
//  ViewController.m
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 10.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "TableController.h"

@interface TableController () {

    NSMutableArray *contents;

}

@end

@implementation TableController

- (id) initWithFolderPath:(NSString*) path {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
}

- (void) setPath:(NSString *)path {
    
    _path = path;
    NSError *error = nil;
    NSArray *listOfFilesAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    contents = [[NSMutableArray alloc] init];
    
    for (NSString *file in listOfFilesAtPath) {
        if ([self isDirectory:file]) {
            [contents addObject:file];
        }
    }
    
    for (NSString *file in listOfFilesAtPath) {
        if (![self isDirectory:file]) {
            [contents addObject:file];
        }
    }
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    [self.tableView reloadData];
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users";
    }
    
    self.navigationItem.title = [self.path lastPathComponent];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) backToRoot:(UIBarButtonItem*)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*)indexPath {
    
    BOOL isDirectory = NO;
    NSString *fileName = [contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

- (BOOL) isDirectory:(NSString*)file {
    
    NSString *filePath = [self.path stringByAppendingPathComponent:file];
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return  isDirectory;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contents count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fileIdentifier = @"FileCell";
    static NSString *folderIdentifier = @"FolderCell";
    
    NSString *fileName = [contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        cell.textLabel.text = fileName;
        return cell;
        
    } else {
        
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attributes fileSize]];
        cell.dateLabel.text = [[self customDateFormat] stringFromDate:[attributes fileModificationDate]];
        return cell;
        
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [contents objectAtIndex:indexPath.row];
        NSString *newPath = [self.path stringByAppendingPathComponent:fileName];
        TableController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableController"];
        vc.path = newPath;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 44.f;
    } else {
        return 70.f;
    }
}

#pragma mark - Methods for better view of attributes of files

- (NSString*) fileSizeFromValue:(unsigned long long)size {
    
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    int index = 0;
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
    
}

- (NSDateFormatter*) customDateFormat {
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    }
    return dateFormatter;
    
}




@end