//
//  txtEditViewController.m
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import "txtEditViewController.h"
#import "tableViewController.h"
#import "tableDataDelegate.h"
#import "Record.h"

@implementation txtEditViewController

@synthesize txtView, record;

-(tableViewController *)main {
    if (main == nil) {
        main = [[tableViewController alloc] initWithNibName:@"tableView" bundle:nil];
    }
    return main;
}
// Отвечает за поворот интерфейса программы при изменении ориентации iPhone
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// Меняет размеры TextView в зависимости от ориентации аппарата
-(void)resizeTextViewIfNeeded {
    if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        [txtView setFrame:CGRectMake(0, 0, 320, 200)];
    } else {
        [txtView setFrame:CGRectMake(0, 0, 480, 106)];
    }
}

// При повороте интерфейса в редиме редактирования меняет размеры TextView
- (void)RotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (editMode == YES) {
        [self resizeTextViewIfNeeded];
    }
}

-(void)viewWillAppear:(BOOL)animated {
 	
	txtView.text = record.txt;
	editMode = NO;
	imagePickerView = [[UIImagePickerController alloc] init];
	imagePickerView.delegate = self;
}

// Вызываем процедуру окончания редактирования на случай закрытия окна ViewController 
-(void)viewWillDisappear:(BOOL)animated {
    
	    
	[self doneAction:self];
	record.txt = txtView.text;
    tableDataDelegate *appDelegate = [tableDataDelegate alloc];
	[appDelegate updateOrAddRecordIntoDatabase:self.record];
}

// Убирает фокус ввода с поля TextView и удаляет кнопку завершения редактирования с NavigationBar
-(void)doneAction:(id)sender {
    [txtView resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = nil;
	
}

-(void)picture:(id)sender {

if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
[self presentModalViewController:imagePickerView animated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)dictionary {
	record.image = image;
	[imagePickerView dismissModalViewControllerAnimated:YES];
	
}



-(void)dealloc {
    [record release];
    [txtView release];
	[super dealloc];
}


#pragma mark Реализация методов протокола UITextViewDelegate

// Добавляет кнопку завершения редактирования на NavigationBar при начале ввода текста в поле TextView
-(void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = buttonDone;
    [buttonDone release];
    
    [self resizeTextViewIfNeeded];
    editMode = YES;
}

// При выходе из режима редактирования меняет размер TextView на полноэкранный
- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView setFrame:self.view.frame];
    editMode = NO;
	
	//	txtEditAppDelegate *appDelegate = (txtEditAppDelegate *)[[UIApplication sharedApplication] delegate];
   // [appDelegate updateOrAddRecordIntoDatabase:self.record];
}

@end
