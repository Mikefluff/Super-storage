//
//  RootViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "RootViewController.h"
#import "Users.h";
#import "AddViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Rec"];
    if (cell == nil) {
		cell = [self getCellContentView:@"Rec"];
		//		       cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Rec"] autorelease];
    }
	
	//Get the object from the array.
	Users *userObj = [appDelegate.usersArray objectAtIndex:indexPath.row];
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	UIImageView *image = (UIImageView *)[cell viewWithTag:3];
	//Set the coffename.
	lblTemp1.text = userObj.userName;
	lblTemp2.text = userObj.userName;
	image.image = userObj.userImage;
	//Set the accessory type.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Set up the cell
    return cell;
}

//высота ячейки
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	if(edit) {
	if(dvController == nil) 
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	Users *userObj = [appDelegate.usersArray objectAtIndex:indexPath.row];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[userObj hydrateDetailViewData];
	
	dvController.userObj = userObj;
	
	[self.navigationController pushViewController:dvController animated:YES];
	}
	else {
		
	
	
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (Super_storageAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = @"Select User";
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Users *userObj = [appDelegate.usersArray objectAtIndex:indexPath.row];
		[appDelegate removeUser:userObj];
		
		//Delete the object from the table.
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	edit = editing;
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) add_Clicked:(id)sender {
	
	if(avController == nil)
		avController = [[AddViewController alloc] initWithNibName:@"AddView" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:NO];
}

//reimplement cell

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 10, 200, 25);
	CGRect Label2Frame = CGRectMake(10, 33, 200, 25);
	
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Инициализация метки с тегом 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Инициализация метки с тегом 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	UIImageView *imageV;
	imageV = [[UIImageView alloc] initWithFrame:CGRectMake(210, 5, 70, 50)];
	imageV.tag = 3;
	imageV.contentMode = UIViewContentModeScaleAspectFill;
	imageV.clipsToBounds = YES;
	//	[self.contentView addSubview:photo];
	[cell.contentView addSubview:imageV];
	[imageV release];
	
	
	
	return cell;
}



- (void)dealloc {
	[dvController release];
	[addNavigationController release];
	[avController release];
    [super dealloc];
}


@end

