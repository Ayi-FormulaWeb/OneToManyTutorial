//
//  Copyright (c) 2012 Parse. All rights reserved.

#import "NewPostViewController.h"
#import "Parse/Parse.h"

@implementation NewPostViewController

@synthesize textView;

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    [self setTitle:@"Add new post"];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 186)];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView becomeFirstResponder];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonTouchHandler:)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTouchHandler:)]];
    
    [self.view addSubview:textView];
}


#pragma mark - Button handlers

- (void)addButtonTouchHandler:(id)sender 
{
    // Create a new Post object and create relationship with PFUser
    // 新增一個新的Po文並且關聯PFUser用戶。
    PFObject *newPost = [PFObject objectWithClassName:@"Post"];  // 這裡是資料表Classes名稱
    [newPost setObject:[textView text] forKey:@"textContent"];   // 用setObject新增資料表裡面欄位的名稱
    [newPost setObject:[PFUser currentUser] forKey:@"author"]; // One-to-Many relationship created here! 在這裡建立一對多關聯
    
    //Set ACL permissions for added security
    //為增加安全設定ACL權限
    PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [postACL setPublicReadAccess:YES]; //預設公開
    [newPost setACL:postACL];
    
    // Save new Post object in Parse
    // 一個新的Po文物件儲存至Parse資料庫。
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self dismissModalViewControllerAnimated:YES]; // Dismiss the viewController upon success 成功後解散視圖控制器
        }
    }];
}

- (void)cancelButtonTouchHandler:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];   
}

@end
