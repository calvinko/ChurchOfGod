//
//  SettingViewController.m
//  ChurchofGod
//
//  Created by Calvin Ko on 3/9/11.
//  Copyright 2011 KoSolution, Inc. All rights reserved.
//

#import "SettingViewController.h"
#import "ChurchConfigLoader.h"
#import "ConfigManager.h"

@implementation SettingViewController


#pragma mark -
-(id)init
{
	self = [super init];
    churchDetailController = nil;
    return self;
}

#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark NavigationBar 



#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;  // no of sections
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    /*
	 The number of rows varies by section.
	 */
    NSInteger rows = 0;
    switch (section) {
        case 0:
            if ([[ConfigManager getValidUserList] count] > 0) {
                rows = 2;
            } else {
                rows = 1;
            }
            break;
        case 1:
			rows = 2;
            break;
        default:
            break;
    }
    return rows;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the region name -- get this from the region at the section index.
	switch (section) {
        case 0: return @"Church";
        case 1: return @"Performance";
        default:
                return @"";
    }
    return @"";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CellIdentifier";
    static NSString *PWCell = @"PWCell";
    UILabel *mainLabel;
    UITextField *rightTextField;
    
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:PWCell ];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PWCell] autorelease];
            mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(13.0, 10.0, 100.0, 30.0)] autorelease];
            
            mainLabel.tag = 1;            
            mainLabel.font = [UIFont boldSystemFontOfSize:16.0];
            mainLabel.textAlignment = UITextAlignmentLeft;
            mainLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:mainLabel];
            
            rightTextField = [[UITextField alloc] initWithFrame:CGRectMake(180.0, 10.0, 80.0, 30.0)];
            rightTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [rightTextField setDelegate:self];
            [rightTextField setPlaceholder:[ConfigManager getUsername]];
            [rightTextField setFont:[UIFont systemFontOfSize:16]];
            rightTextField.textAlignment = UITextAlignmentCenter;
            rightTextField.textColor = [UIColor blackColor];
            [cell.contentView addSubview:rightTextField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            mainLabel = (UILabel *)[cell.contentView viewWithTag:1];
        }
        mainLabel.text = @"UserType";  
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
        }
    }
  
    // Cache a date formatter to create a string representation of the date object.
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    // Set the text in the cell for the section/row.    
    switch (indexPath.section) {
        case 0:
			if (indexPath.row==0) {
				cell.detailTextLabel.text = nil;
				cell.textLabel.text = [ConfigManager getChurchname];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else {
                if ([[ConfigManager getValidUserList] count] > 0) {
                    //cell.textLabel.text = @"Usertype";
                    //cell.detailTextLabel.text = [ConfigManager getUsername];
                    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                };
			}
            break;
        case 1:
			if (indexPath.row==0) {
				cell.textLabel.text = @"Download Items";
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setTitle: @"Click" forState: UIControlStateNormal ];
                [button addTarget: self action: @selector(edit:) forControlEvents: UIControlEventTouchUpInside ];
                [cell.contentView addSubview:button];
			} else {
				cell.textLabel.text = @"Memory Used";
			}
            break;
		default:
            break;
    }
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    switch (indexPath.section) {
        case 0:
			if (indexPath.row==0) {
                if (churchDetailController == nil) {
                    churchDetailController = [[ChurchDetailController alloc] init];
                }
                
                churchDetailController.churchArray = [ConfigManager getChurchArray];

                [self.navigationController pushViewController:churchDetailController animated:YES];
                
                    
			} else {
            }
            
            break;
        case 1:
			if (indexPath.row==0) {
				
			} else {
            }
            break;
		default:
            break;
    }
    

		
    /*
     *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [ConfigManager setUser:textField.text];
    [textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

