//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface PickerViewController : UIViewController <UIPickerViewDelegate> {

	RootViewController *rvController;
	IBOutlet UIPickerView *picker;
	NSMutableArray *arrayNo;
	NSMutableArray *code;
	NSMutableString *secret;
	
}

@property (nonatomic, retain) RootViewController *rvController;

@end
