//
//  SpinViewController.h
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowMultiplier				100
#define kAccelerationThreshold		2.2
#define kUpdateInterval				(1.0f/10.0f)

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAccelerometerDelegate, UIActionSheetDelegate>
{
	UIPickerView	*picker;
	UIButton		*spinButton;
	IBOutlet UILabel *mlabel6;
	
	
	NSMutableArray *code;
	NSMutableString *secret;
	
	NSArray			*component1Data;
	NSArray			*component2Data;
	NSArray			*component3Data;
	NSArray			*component4Data;
	NSArray			*component5Data;
	NSArray			*component6Data;
	
	NSArray			*component1Labels;
	NSArray			*component2Labels;
	NSArray			*component3Labels;
	NSArray			*component4Labels;
	NSArray			*component5Labels;
	NSArray			*component6Labels;
	
	NSArray			*component1BlurredLabels;
	NSArray			*component2BlurredLabels;
	NSArray			*component3BlurredLabels;
	NSArray			*component4BlurredLabels;
	NSArray			*component5BlurredLabels;
	NSArray			*component6BlurredLabels;
	
@private
	BOOL			isSpinning;
	NSUInteger		spin1;
	NSUInteger		spin2;	
	NSUInteger		spin3;
	NSUInteger		spin4;
	NSUInteger		spin5;
	NSUInteger		spin6;
	
}
@property (nonatomic, retain) UILabel *mlabel6;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIButton *spinButton;
@property (nonatomic, retain) NSArray *component1Data;
@property (nonatomic, retain) NSArray *component2Data;
@property (nonatomic, retain) NSArray *component3Data;
@property (nonatomic, retain) NSArray *component4Data;
@property (nonatomic, retain) NSArray *component5Data;
@property (nonatomic, retain) NSArray *component6Data;
@property (nonatomic, retain) NSArray *component1Labels;
@property (nonatomic, retain) NSArray *component2Labels;
@property (nonatomic, retain) NSArray *component3Labels;
@property (nonatomic, retain) NSArray *component4Labels;
@property (nonatomic, retain) NSArray *component5Labels;
@property (nonatomic, retain) NSArray *component6Labels;
@property (nonatomic, retain) NSArray *component1BlurredLabels;
@property (nonatomic, retain) NSArray *component2BlurredLabels;
@property (nonatomic, retain) NSArray *component3BlurredLabels;
@property (nonatomic, retain) NSArray *component4BlurredLabels;
@property (nonatomic, retain) NSArray *component5BlurredLabels;
@property (nonatomic, retain) NSArray *component6BlurredLabels;
- (IBAction)spin;
- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray;
- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray;
@end

