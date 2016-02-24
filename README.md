# Simple File Manager for simulator
This file manager allows you to surf through the files on your hard drive, beginning from main folder Users. 

## In this application you can:
* watch lists of you files in all folders  
* see the content that is sorted by directories and files, and also alphabetically  
* see name of files, its extension, size and last modification date  
* delete files  
* go to home folder by one click from any place
* open image files
* search in folder by name and quickly find necessary file

## In this app I used:
1. NSFileManager for listing contents of folders, managing them for deleting, and sort by its type.
2. Dictionary with attributes of files for showing them in table cells, and make some methods for giving them a better view (such as date formatter and basic understanding of file sizes).  
3. TableViewController for listing files, expecially its TableViewDelegate and TableViewDataSource, reusable cells and actions by selecting them.
4. TableView editing style for making changes in contents of folders, such as deleting files.
5. NavigationController for easy surfing through folders and back in previous directory.  
6. Navigation bar items to enable editing mode and returning to home directory.
7. Working with special methods of NSString class for strings with path to files and folders.
8. Assets file for using custom images.
9. Working with identifiers for customizing cells and make them better view.
10. UISearchBar and its delegate for searching files by names (it can be one letter or the whole word) for showing you updated list of files that match this criteria.
11. NSOperation and NSBlockOperation to speed-up search, move it to background thread and its cancelling if needed, if there are many files in folder for preventing slowdown of system. 

##Screenshots:
![Alt text](http://clip2net.com/clip/m496854/18477-clip-51kb.jpg "Optional title")
![Alt text](http://clip2net.com/clip/m496854/b046f-clip-60kb.jpg "Optional title")
![Alt text](http://clip2net.com/clip/m496854/3aa3d-clip-54kb.jpg "Optional title")
