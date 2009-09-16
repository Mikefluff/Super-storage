//
//  txtEditViewController.h
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Record;
@class tableViewController;

@interface txtEditViewController: UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    tableViewController *main;
	IBOutlet UITextView *txtView;
    Record *record;
	UIImagePickerController *imagePickerView;
    // Индикатор режима редактирования
    BOOL editMode;
	
}

@property (nonatomic, retain) UITextView *txtView;
@property (nonatomic, retain) Record *record;


-(void)doneAction:(id)sender;
-(void)picture:(id)sender;
-(void)resizeTextViewIfNeeded;

@end
