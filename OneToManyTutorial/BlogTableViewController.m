//
//  Copyright (c) 2012 Parse. All rights reserved.

#import "BlogTableViewController.h"
#import "NewPostViewController.h"
#import "Parse/Parse.h"

@implementation BlogTableViewController

@synthesize postArray;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Posts"];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonHandler:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPostButtonHandler:)]];
}

- (void)viewWillAppear:(BOOL)animated 
{
    if ([PFUser currentUser])
        [self refreshButtonHandler:nil];
}

#pragma mark - Button handlers
// 刷新處理程序按鈕事件
- (void)refreshButtonHandler:(id)sender 
{
    //Create query for all Post object by the current user
    //新增對所有Po文搜尋，對象為當前用戶[PFUser currentUser]
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    
    // Run the query
    // 執行搜尋
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the table
            //儲存搜尋結果，並更新至Table
            postArray = objects; 
            [self.tableView reloadData];
        }
    }];
}


// 新增Po文處理程序按鈕
- (void)addPostButtonHandler:(id)sender 
{
    NewPostViewController *newPostViewController = [[NewPostViewController alloc] init];
    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:newPostViewController] animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // 回傳行數
    return postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell with the textContent of the Post as the cell's text label
    PFObject *post = [postArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[post objectForKey:@"textContent"]];
    
    return cell;
}


@end
