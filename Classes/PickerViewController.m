//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "PickerViewController.h"
#import "RootViewController.h"
#define EXTRA_COMPONENTS (10)

@implementation PickerViewController

@synthesize rvController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
//[rvController doneSearching_Clicked:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:YES];
	arrayNo = [[NSMutableArray alloc] init];
	[arrayNo addObject:@"1"];
	[arrayNo addObject:@"2"];
	[arrayNo addObject:@"3"];
	[arrayNo addObject:@"4"];
	[arrayNo addObject:@"5"];
	[arrayNo addObject:@"6"];
	[arrayNo addObject:@"7"];
	[arrayNo addObject:@"8"];
	[arrayNo addObject:@"9"];
	code = [[NSMutableArray alloc] init];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	secret = [NSMutableString stringWithCapacity:6];
	
	
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 6;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if(row < EXTRA_COMPONENTS) {
		row += 100;
		[pickerView selectRow:row inComponent:0 animated:NO];
		return;
	} else if(row >= 100 + EXTRA_COMPONENTS) {
		row -= 100;
		[pickerView selectRow:row inComponent:0 animated:NO];
	return;}
	
	
	secret = [[NSMutableString alloc] initWithString:@""];
	switch (component) {
		case 0:	
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];
			break;
		case 1:
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];
			
			break;
		case 2:
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];			
			break;
		case 3:
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];		
			break;
		case 4:
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];			
			break;
		case 5:
			
			[code replaceObjectAtIndex:component withObject:[arrayNo objectAtIndex:row]];		
			break;
			
	}
	for (int i=0;i<6;i++)
	{
		[secret appendString:[code objectAtIndex:i]];
	}
//	mlabel6.text = secret;
	//	if (secret = @"777777")
	//	{
	
	
	//	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return 100 + EXTRA_COMPONENTS * 2; // Increase number of components by 10 per side
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [arrayNo objectAtIndex:row];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[rvController release];
    [super dealloc];
}


@end
