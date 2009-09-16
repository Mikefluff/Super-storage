//
//  mainViewController.m
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import "tableViewController.h"
#import "txtEditViewController.h"
#import "txtEditAppDelegate.h"
#import "Record.h"
#import "OverlayViewController.h"


@implementation tableViewController

@synthesize listView;
@synthesize copylistOfItems;
@synthesize search;
@synthesize searchb;


-(txtEditViewController *)txtViewController {
    if (txtViewController == nil) {
        txtViewController = [[txtEditViewController alloc] initWithNibName:@"txtEdit" bundle:nil];
    }
    return txtViewController;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#pragma mark Реализация методов свойств

// Читаем интерфейс окна редактирования из внешнего файла txtEdit.xib


#pragma mark Реализация методов класса UIViewController

// Создаем стиль кнопки возврата к списку документов


-(void)viewWillAppear:(BOOL)animated {
    NSIndexPath *selectedIndexPath = [listView indexPathForSelectedRow];
//    txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[listView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    
    [listView reloadData];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			target:self
																			action:@selector(button:)];
    self.navigationItem.rightBarButtonItem = button;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Back";
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	UISearchBar *searchb = [[UISearchBar alloc] init];
	copylistOfItems = [[NSMutableArray alloc]init];
	//listView.tableHeaderView = searchb;
    searchb.autocorrectionType = UITextAutocorrectionTypeNo;
	searching = NO;
	letUserSelectRow = YES;

//	copy = [[NSMutableArray alloc]init];
//	[copy addObjectsFromArray:appDelegate.records];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    [super setEditing:editing animated:animate];
    [listView setEditing:editing animated:animate];
}


#pragma mark Реализация собственных методов

// Вызывает появление окна создания нового документа
- (void)button:(id)sender {
    txtEditViewController *controller = self.txtViewController;
    controller.record = [[[Record alloc] init] autorelease];
    [[self navigationController] pushViewController:controller animated:YES];
}


#pragma mark Реализация протокола UITableViewDelegate

// Возвращает ячейку по ее номеру для формирования таблицы
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Rec"];
    
    if (cell == nil) {
    cell = [self getCellContentView:@"Rec"];
//		       cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Rec"] autorelease];
    }

    if(searching) 
		cell.text = [copylistOfItems objectAtIndex:indexPath.row];
	else {
		UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
		UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
		UIImageView *image = (UIImageView *)[cell viewWithTag:3];
    // Получаем ссылку на делегат класса UIApplication и доступ к его переменным
    txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
    Record *record = (Record *)[appDelegate.records objectAtIndex:indexPath.row];
    
   // cell.text
		[record readRecord];
		lblTemp1.text = record.txt;
		lblTemp2.text = @"Sub Value";
		image.image = record.image;
	}
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 60;
}

// Вызывает открытие окна редактирования для выбранного документа в таблице
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 //   if(searching)
//		return;
//	else
//	{
	txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
    txtEditViewController *controller = self.txtViewController;
    
    Record *record = (Record *)[appDelegate.records objectAtIndex:indexPath.row];
    
	[record readRecord];
    controller.record = record;
    
    [[self navigationController] pushViewController:controller animated:YES];
//}
}

//удаление строки
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
     txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (editingStyle == UITableViewCellEditingStyleDelete) {
 //       [listView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//						withRowAnimation:UITableViewRowAnimationFade];
		Record *record = (Record *)[appDelegate.records objectAtIndex:indexPath.row];
		[record deleteRecord];
		[appDelegate.records removeObject:record];
		[listView reloadData];
    }
}


#pragma mark Реализация протокола UITableViewDataSource

// Возвращает число секций в таблице
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (searching)
		return 1;
	else
		//int count = [appDelegate.records count];
		return 1;//count;}

}

// Возвращает число строк для указанной секции
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching)
		return [copylistOfItems count];
	else {
		txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.records count];
	}
}

- (NSIndexPath *)tableView :(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}


#pragma mark Полоса прокрутки

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if(searching)
		return nil;
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"1"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"3"];
	[tempArray addObject:@"4"];
	[tempArray addObject:@"5"];
	[tempArray addObject:@"6"];
	[tempArray addObject:@"7"];
	[tempArray addObject:@"8"];
	[tempArray addObject:@"9"];
	[tempArray addObject:@"10"];
	[tempArray addObject:@"11"];
	[tempArray addObject:@"12"];
	[tempArray addObject:@"13"];
	[tempArray addObject:@"14"];
	[tempArray addObject:@"15"];
	[tempArray addObject:@"16"];
	[tempArray addObject:@"17"];
	[tempArray addObject:@"18"];
	[tempArray addObject:@"19"];
	[tempArray addObject:@"20"];
	[tempArray addObject:@"21"];
	[tempArray addObject:@"22"];
	[tempArray addObject:@"23"];
	[tempArray addObject:@"24"];
	[tempArray addObject:@"25"];
	[tempArray addObject:@"26"];
	
	return tempArray;
}

//reimplement Cell
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





#pragma mark -
#pragma mark Search Bar 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[listView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[listView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	listView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
	
}

//- (void) reloadDataMyTable
//{
 //   [self setUpDisplayList];
	
 //   [listView reloadData];
	
//}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	//txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
[listView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	[copylistOfItems removeAllObjects];// remove all data that belongs to previous search
	search = searchText;
	if([searchText length] > 0) {
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		listView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		[listView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		searching = NO;
		letUserSelectRow = NO;
		listView.scrollEnabled = NO;
	}	
	[listView reloadData];
}







- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
[self searchTableView];
}

- (void) searchTableView {
	txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSMutableArray *searchArray = [appDelegate.records copy];	
	    
	for (NSString *sTemp in searchArray)
	{
		Record *record = (Record *)sTemp;
		
		NSString *uTemp = record.title;
		NSRange titleResultsRange = [uTemp rangeOfString:search options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copylistOfItems addObject:uTemp];
	}
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	search = @"";
	[self.searchb resignFirstResponder];
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[listView reloadData];
}




-(void)dealloc {
    [listView release];
    [txtViewController release];
    
    [super dealloc];
}


@end
