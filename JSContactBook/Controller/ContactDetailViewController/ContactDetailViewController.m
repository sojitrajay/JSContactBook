//
//  ContactDetailViewController.m
//  JSContactBook
//
//  Created by Jayesh on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactImageTableViewCell.h"
#import "UIImageView+AGCInitials.h"

typedef enum : NSUInteger {
    ContactCellTypeImage = 0,
    ContactCellTypeCount
} ContactCellType;

@interface ContactDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ContactCellTypeCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ContactCellTypeImage) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeImage) {
        return 144.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeImage) {
        ContactImageTableViewCell *cell = (ContactImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            
            // Set name
            [cell.labelContactName setText:self.contact.displayName.string];
            
            // Set image
            if (self.contact.imageData!=nil && self.contact.thumbnailImageData!=nil) {
                [cell.imageViewContact setImage:[UIImage imageWithData:(self.contact.imageData!=nil)?self.contact.imageData:self.contact.thumbnailImageData]];
            }
            else
            {
                [cell.imageViewContact agc_setImageWithInitialsFromName:self.contact.displayName.string];
            }
            
            [cell.imageViewContact.layer setCornerRadius:cell.imageViewContact.frame.size.width/2];
            cell.imageViewContact.clipsToBounds = YES;
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
    
}


@end
