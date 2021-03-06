//
//  ViewController.m
//  SimpleFileManagerForSimulator
//
//  Created by Admin on 10.02.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "TableController.h"
#import "ImageController.h"

@interface TableController () {

    NSMutableArray *contents;
    NSArray *fullContents;
    FileCell *selectedFile;
    NSOperation *currentOperation;

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
            if (![[file substringToIndex:1] isEqualToString:@"."]) {
                [contents addObject:file];
            }
        }
    }
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    fullContents = [NSArray arrayWithArray:contents];
    [self.tableView reloadData];
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users";
    }
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash"] style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
    NSArray *barButtonsArray = [NSArray arrayWithObjects:deleteButton, homeButton, nil];
    self.navigationItem.rightBarButtonItems = barButtonsArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ImageSegue"]) {
        ImageController *ic = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedFile];
        NSString *fileName = [contents objectAtIndex:indexPath.row];
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        ic.filePath = filePath;
        ic.fileName = selectedFile.nameLabel.text;;
    }
    
}

#pragma mark - Private Methods

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

- (void) actionEdit:(UIBarButtonItem*)sender {
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    UIImage *image = [UIImage imageNamed:@"Trash"];
    if (self.tableView.editing) {
        image = [UIImage imageNamed:@"Done"];
    }
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
}

- (void) backToRoot:(UIBarButtonItem*)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showFilesAccordintToSearchBar {
    
    [currentOperation cancel];
    __weak typeof(self) weakSelf = self;
    NSString *filterString = self.searchBar.text;
    
    currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *filesArray = [[NSMutableArray alloc] init];
        for (NSString *string in fullContents) {
            if ([filterString length] > 0 && [string rangeOfString:filterString].location == NSNotFound) {
                continue;
            }
            [filesArray addObject:string];
        }
        contents = filesArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            currentOperation = nil;
        });
    }];
    
    [currentOperation start];
    
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
        
        if (fileName.length > 20) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@...", [fileName substringToIndex:20]];
        } else {
            cell.nameLabel.text = [fileName stringByDeletingPathExtension];
            
        }
        
        cell.extensionLabel.text = [fileName pathExtension];
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
        
    } else {
        selectedFile = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectedFile.extensionLabel.text isEqualToString:@"png"] ||
            [selectedFile.extensionLabel.text isEqualToString:@"jpg"])
        {
            [self performSegueWithIdentifier:@"ImageSegue" sender:nil];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 44.f;
    } else {
        return 70.f;
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = [contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    BOOL removeFile = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    if (removeFile) {
        [contents removeObject:fileName];
    }
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self showFilesAccordintToSearchBar];
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

#pragma mark - Actions

- (IBAction)homeButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
