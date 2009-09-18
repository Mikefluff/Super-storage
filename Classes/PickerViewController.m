//
//  SpinViewController.m
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import "PickerViewController.h"
#import "UIView-GetImageOf.h"
#import "UIImage-Blur.h"

@interface UIPickerView(SoundsEnabledPrivate)
- (void)setSoundsEnabled:(BOOL)isEnabled;
@end

@interface UIImage(ResizePrivate)
- (id)_imageScaledToSize:(struct CGSize)size interpolationQuality:(int)quality;
@end

@implementation PickerViewController
@synthesize mlabel6;
@synthesize picker;
@synthesize spinButton;
@synthesize component1Data;
@synthesize component2Data;
@synthesize component3Data;
@synthesize component4Data;
@synthesize component5Data;
@synthesize component6Data;
@synthesize component1Labels;
@synthesize component2Labels;
@synthesize component3Labels;
@synthesize component4Labels;
@synthesize component5Labels;
@synthesize component6Labels;
@synthesize component1BlurredLabels;
@synthesize component2BlurredLabels;
@synthesize component3BlurredLabels;
@synthesize component4BlurredLabels;
@synthesize component5BlurredLabels;
@synthesize component6BlurredLabels;

- (void)stopBlurring
{
	isSpinning = NO;
}
- (IBAction)spin
{	
	if (! isSpinning)
	{
		// Calculate a random index in the array
		spin1 = arc4random()%[component1Data count];
		spin2 = arc4random()%[component1Data count];
		spin3 = arc4random()%[component1Data count];	
		spin4 = arc4random()%[component1Data count];
		spin5 = arc4random()%[component1Data count];
		spin6 = arc4random()%[component1Data count];
		
		// Put first and third component near top, second near bottom
		[picker selectRow:([picker selectedRowInComponent:0]%[component1Data count]) + [component1Data count] inComponent:0 animated:NO];
		[picker selectRow:(kRowMultiplier - 2) * [component2Data count] + spin2 inComponent:1 animated:NO];
		[picker selectRow:(kRowMultiplier - 2) * [component3Data count] + spin3 inComponent:2 animated:NO];
		[picker selectRow:(kRowMultiplier - 2) * [component4Data count] + spin4 inComponent:3 animated:NO];
		[picker selectRow:(kRowMultiplier - 2) * [component5Data count] + spin5 inComponent:4 animated:NO];
		[picker selectRow:([picker selectedRowInComponent:2]%[component6Data count]) + [component6Data count] inComponent:5 animated:NO];
		
		// Spin to the selected value
		[picker selectRow:(kRowMultiplier - 2) * [component1Data count] + spin1 inComponent:0 animated:YES];
		[picker selectRow:spin2 + [component2Data count] inComponent:1 animated:YES];
		[picker selectRow:spin3 + [component3Data count] inComponent:2 animated:YES];
		[picker selectRow:spin4 + [component4Data count] inComponent:3 animated:YES];
		[picker selectRow:spin5 + [component5Data count] inComponent:4 animated:YES];
		[picker selectRow:(kRowMultiplier - 2) * [component6Data count] + spin6 inComponent:5 animated:YES];
		
		isSpinning = YES;
		
		// Need to have it stop blurring a fraction of a second before it stops spinning so that the final appearance is not blurred.
		[self performSelector:@selector(stopBlurring) withObject:nil afterDelay:0.7];
	}
}
- (NSArray *)arrayForComponent:(NSInteger)index
{
	NSString *arrayName = [NSString stringWithFormat:@"component%dLabels", index+1];
	return [self valueForKey:arrayName];
}
- (NSArray *)blurredArrayForComponent:(NSInteger)index
{
	NSString *arrayName = [NSString stringWithFormat:@"component%dBlurredLabels", index+1];
	return [self valueForKey:arrayName];
}
#pragma mark -
- (void)_reenablePickerSound
{
	[picker setSoundsEnabled:YES];
}
- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray
{
	NSMutableArray *blurred = [NSMutableArray array];
	for (UILabel *oneLabel in labelArray)
	{
		UIImage *image = [oneLabel getAsImage];
		UIImage *scaledImage = [image _imageScaledToSize:CGSizeMake(image.size.width / 5.0, image.size.width / 5.0) interpolationQuality:3.0];
		UIImage *labelImage = [scaledImage _imageScaledToSize:image.size interpolationQuality:3.0];
		UIImageView *labelView = [[UIImageView alloc] initWithImage:labelImage];
		[blurred addObject:labelView];
		[labelView release];
		
	}
	return blurred;
}
- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray
{
	NSMutableArray *labels = [NSMutableArray array];
	for (NSString *oneValue in stringArray)
	{
		UILabel *tempLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 15.0)];
		tempLabel.text = oneValue;
		tempLabel.font = [UIFont boldSystemFontOfSize:20.0];
		tempLabel.backgroundColor = [UIColor clearColor];
		[labels addObject:tempLabel];
		[tempLabel release];
	}
	return labels;
}
#pragma mark -
- (void)viewDidLoad 
{	
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = kUpdateInterval;
	
	isSpinning = NO;
	[picker setSoundsEnabled:NO];
	
	// Dummy data to display
	self.component1Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	self.component2Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	self.component3Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	self.component4Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	self.component5Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	self.component6Data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
	
	// Create UILabels out of them
	self.component1Labels = [self labelArrayFromStringArray:component1Data];
	self.component2Labels = [self labelArrayFromStringArray:component2Data];
	self.component3Labels = [self labelArrayFromStringArray:component3Data];
	self.component4Labels = [self labelArrayFromStringArray:component4Data];
	self.component5Labels = [self labelArrayFromStringArray:component5Data];
	self.component6Labels = [self labelArrayFromStringArray:component6Data];
	
	// Create blurred UIImageViews out of the labels - we don't want to be blurring every time, so we do on load and cache
	self.component1BlurredLabels = [self blurredLabelArrayFromLabelArray:component1Labels];
	self.component2BlurredLabels = [self blurredLabelArrayFromLabelArray:component2Labels];
	self.component3BlurredLabels = [self blurredLabelArrayFromLabelArray:component3Labels];
	self.component4BlurredLabels = [self blurredLabelArrayFromLabelArray:component4Labels];
	self.component5BlurredLabels = [self blurredLabelArrayFromLabelArray:component5Labels];
	self.component6BlurredLabels = [self blurredLabelArrayFromLabelArray:component6Labels];
	
	[picker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[picker selectRow: [component2Data count] * (kRowMultiplier / 2) inComponent:1 animated:NO];
	[picker selectRow: [component3Data count] * (kRowMultiplier / 2) inComponent:2 animated:NO];
	[picker selectRow: [component4Data count] * (kRowMultiplier / 2) inComponent:3 animated:NO];
	[picker selectRow: [component5Data count] * (kRowMultiplier / 2) inComponent:4 animated:NO];
	[picker selectRow: [component6Data count] * (kRowMultiplier / 2) inComponent:5 animated:NO];
	
	[self performSelector:@selector(_reenablePickerSound) withObject:nil afterDelay:0.25];
	
	code = [[NSMutableArray alloc] init];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	[code addObject:@"1"];
	secret = [NSMutableString stringWithCapacity:6];
	
	
    [super viewDidLoad];
}

- (void)dealloc 
{
	[picker release];
	[spinButton release];
	[component1Data release];
	[component2Data release];
	[component3Data release];
	[component4Data release];
	[component5Data release];
	[component6Data release];
	[component1Labels release];
	[component2Labels release];
	[component3Labels release];
	[component4Labels release];
	[component5Labels release];
	[component6Labels release];
	[component1BlurredLabels release];
	[component2BlurredLabels release];
	[component3BlurredLabels release];
	[component4BlurredLabels release];
	[component5BlurredLabels release];
	[component6BlurredLabels release];
    [super dealloc];
}
#pragma mark -
#pragma mark UIPickerViewDelegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{	
	int actualRow = row%[[self arrayForComponent:component] count];
	
	if (!isSpinning)
	{
		NSArray *componentArray = [self arrayForComponent:component];
		return [componentArray objectAtIndex:actualRow];
	}
	
	NSArray *componentArray = [self blurredArrayForComponent:component];
	
	[picker selectRow: actualRow inComponent:component animated:NO];
	return [componentArray objectAtIndex:actualRow];
	
	
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSArray *componentArray = [self arrayForComponent:component];
	int actualRow = row%[componentArray count];
	
	int newRow = ([componentArray count] * (kRowMultiplier / 2)) + actualRow;
	[picker selectRow:newRow inComponent:component animated:NO];
	
	secret = [[NSMutableString alloc] initWithString:@""];

	//NSInteger test = [pickerView selectedRowInComponent:0]%[componentArray count];	
	for (int i=0;i<6;i++)
	{
		NSArray *componentArray = [self arrayForComponent:i];
		[secret appendString:[component1Data objectAtIndex:[pickerView selectedRowInComponent:i]%[componentArray count]]];
	}
	mlabel6.text = secret;
	
	
}
#pragma mark -
#pragma mark UIPickerViewDatasource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 6;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[self arrayForComponent:component] count] * kRowMultiplier;
}
#pragma mark -
#pragma mark UIAccelerometerDelegate Methods
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{	
	if (fabsf(acceleration.x) > kAccelerationThreshold || fabsf(acceleration.y) > kAccelerationThreshold || fabsf(acceleration.z) > kAccelerationThreshold) 
		[self spin];	
}


#pragma mark -
#pragma mark UIActionSheet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		NSLog(@"ok");
	}
	if (!(buttonIndex == [actionSheet cancelButtonIndex])) {
		NSString *msg = nil;
		
	//	if (nameField.text.length > 0)
	//		msg = [[NSString alloc] initWithFormat:
	//			   @"You can breathe easy, %@, everything went OK.",
	//			   nameField.text];
	//	else
		[self spin];
	}
}


@end
