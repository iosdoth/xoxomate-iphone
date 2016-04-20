//
//  Helper.m
//  iPhoneBasicStructure
//
//  Created by _MyCompanyName_ on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation Helper

#pragma mark - AlertView

+(void)showAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage delegate:(id)pDelegate{
    [[[UIAlertView alloc]initWithTitle:pstrTitle message:pstrMessage delegate:pDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

+(void)showYesNoAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage tag:(NSInteger)pTag delegate:(id)pDelegate{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:pstrTitle message:pstrMessage delegate:pDelegate cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO",nil];
	alertView.tag = pTag;
	[alertView show];
}

+(void)showInAppAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage tag:(NSInteger)pTag delegate:(id)pDelegate{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:pstrTitle message:pstrMessage delegate:pDelegate cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Buy Now",nil];
	alertView.tag = pTag;
	[alertView show];
}

+ (void)siAlertView:(NSString*)title msg:(NSString*)msg{
//    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:msg];
//    [alertView addButtonWithTitle:@"OK"
//                             type:SIAlertViewButtonTypeDestructive
//                          handler:^(SIAlertView *alert) {
//                          }];
//    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
//    [alertView show];
}

#pragma mark - Add and remove Done button

+(void)registerKeyboardNotification:(id)pObserver{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[NSNotificationCenter defaultCenter] addObserver:pObserver selector:@selector(sfkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:pObserver selector:@selector(sfkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#pragma clang diagnostic pop
}

+(void)deRegisterKeyboardNotification:(id)pObserver{
	[[NSNotificationCenter defaultCenter] removeObserver:pObserver name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:pObserver name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Address From Lat Long

//+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude{
//	NSString *urlString = [NSString stringWithFormat:kGeoCodingString,pdblLatitude, pdblLongitude];
//	NSError* error;
//	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
//	locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//	return [locationString substringFromIndex:6];
//}

+(CLLocationCoordinate2D)getLatLonFromAddress:(NSString*)strAddress{
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",[strAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    double latitude = 0.0;
    double longitude = 0.0;
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]){
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
	}
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
    return location;
}

#pragma mark - String Functions

+(NSString*)getStringFromDate:(NSDate*)pDate withFormat:(NSString*)pDateFormat{
	NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
	[dtFormatter setDateFormat:pDateFormat];
	return [dtFormatter stringFromDate:pDate];
}

+(NSDate*)getDateFromString:(NSString*)pStrDate withFormat:(NSString*)pDateFormat{
	NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
	[dtFormatter setDateFormat:pDateFormat];
	return [dtFormatter dateFromString:pStrDate];
}

+(NSString*)dateStringFromString:(NSString *)dateToConver format:(NSString *)fromFormat toFormat:(NSString *)toFormat{
    NSDate *date = [Helper getDateFromString:dateToConver withFormat:fromFormat];
    return [Helper getStringFromDate:date withFormat:toFormat];
}

//+(NSMutableString*)getRandomString:(NSInteger)pIntLength{
//	NSMutableString *strPassword = [[NSMutableString alloc]init];
//	for (int i = 0; i < pIntLength; i++){
//		NSInteger intTag = arc4random() % [kRandomPasswordString length];
//		char str = [kRandomPasswordString characterAtIndex:intTag];
//		[strPassword appendString:[NSString stringWithFormat:@"%c",str]];
//	}
//	return strPassword;
//}

#pragma mark - NSUserDefaults

+(void)addToNSUserDefaults:(id)pObject forKey:(NSString*)pForKey{
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	[defaults setObject:pObject forKey:pForKey];
	[defaults synchronize];	
}

+(void)removeFromNSUserDefaults:(NSString*)pForKey{
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:pForKey];
	[defaults synchronize];		
}

+(id)getFromNSUserDefaults:(NSString*)pForKey{
	id pReturnObject;
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	pReturnObject = [defaults valueForKey:pForKey];
	return pReturnObject;
}

+(void)addBoolToUserDefaults:(BOOL)pBool forKey:(NSString *)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	[defaults setBool:pBool forKey:pForKey];
	[defaults synchronize];
}

+(BOOL)getBoolFromUserDefaults:(NSString*)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	BOOL valid = [defaults boolForKey:pForKey];
	return valid;
}

+ (void)addIntToUserDefaults:(NSInteger)tag forKey:(NSString*)pForKey{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	[defaults setInteger:tag forKey:pForKey];
	[defaults synchronize];
}

+ (NSInteger)getIntFromNSUserDefaults:(NSString*)pForKey{
	NSInteger returnObj = 0;
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
	returnObj = [defaults integerForKey:pForKey];
	return returnObj;
}

#pragma mark - Local Notification

//+(void)setLocalNotification:(NSString *)pStrNotificationTitle{
//	Class cls = NSClassFromString(@"UILocalNotification");
//	if (cls != nil){
//		UILocalNotification *notif = [[cls alloc] init];
//		notif.fireDate = [NSDate date];
//		notif.timeZone = [NSTimeZone systemTimeZone];
//		notif.alertBody = [NSString stringWithFormat:@"%@, %@",pStrNotificationTitle,kNotificationMessage];
//		notif.alertAction = @"Show me";
//		notif.soundName = UILocalNotificationDefaultSoundName;
//		notif.applicationIconBadgeNumber = 1;
//		
//		NSDictionary *userDict = [NSDictionary dictionaryWithObject:pStrNotificationTitle forKey:kRemindMeNotificationDataKey];
//		notif.userInfo = userDict;
//		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
//	}		
//}
//
//+(void)setLocalNotificationWithDate:(NSDate *)pDateTime withNotificationTitle:(NSString *)pStrNotificationTitle{
//	Class cls = NSClassFromString(@"UILocalNotification");
//	if (cls != nil){
//		UILocalNotification *notif = [[cls alloc] init];
//		notif.fireDate = pDateTime;
//		notif.timeZone = [NSTimeZone systemTimeZone];
//		notif.alertBody = [NSString stringWithFormat:@"%@, %@",pStrNotificationTitle,kNotificationMessage];
//		notif.alertAction = @"Show me";
//		notif.soundName = UILocalNotificationDefaultSoundName;
//		notif.applicationIconBadgeNumber = 1;
//		
//		NSDictionary *userDict = [NSDictionary dictionaryWithObject:pStrNotificationTitle forKey:kRemindMeNotificationDataKey];
//		notif.userInfo = userDict;
//		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
//	}
//}
//
//+(void)removeLocalNotificationIfSet:(NSString *)pStrNotificationTitle{
//	NSMutableArray *arrLocalNotifications=[[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
//	for (int k=0;k<[arrLocalNotifications count];k++){
//		UILocalNotification *notification=[arrLocalNotifications objectAtIndex:k];
//		NSString *strListName=[notification.userInfo valueForKey:kRemindMeNotificationDataKey];
//		if([strListName isEqualToString:pStrNotificationTitle]){
//			[[UIApplication sharedApplication] cancelLocalNotification:notification];
//			break;
//		}
//	}
//}

+(NSString*)getDocumentDirectoryPath:(NSString*)pStrPathName{
	NSString *strPath=nil;
//	if(pStrPathName)
//		strPath = [[kUserDirectoryPath objectAtIndex:0] stringByAppendingPathComponent:pStrPathName];
	return strPath;
}

#pragma mark - Camera Availability

+(BOOL)isCameraDeviceAvailable{
	BOOL isCameraAvailable=NO;
	if([UIImagePickerController	isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
			isCameraAvailable = YES;
	}
	return isCameraAvailable;
}

+(BOOL)isFrontCameraDeviceAvailable{
	BOOL isCameraAvailable=NO;
	if([UIImagePickerController	isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
			isCameraAvailable = YES;
	}
	return isCameraAvailable;
}

+(BOOL)isRearCameraDeviceAvailable{
	BOOL isCameraAvailable=NO;
	if([UIImagePickerController	isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
			isCameraAvailable = YES;
	}
	return isCameraAvailable;
}

#pragma mark - Image scaling

+(void)showCamera:(id)pController{
    if([Helper isCameraDeviceAvailable]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = pController;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [pController presentViewController:imagePicker animated:YES completion:nil];
    }else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"" image:nil];
    }
}

+(void)showPhotoLibrary:(id)pController{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = pController;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [pController presentModalViewController:imagePicker animated:YES];
    [pController presentViewController:imagePicker animated:YES completion:nil];

}

+(UIImagePickerControllerCameraDevice)getAvailableCamera{
	UIImagePickerControllerCameraDevice availableDevice = NSNotFound;
	if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
		availableDevice = UIImagePickerControllerCameraDeviceFront;
	else if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
		availableDevice = UIImagePickerControllerCameraDeviceRear;
	return availableDevice;
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)imageScaleAndCropToMaxSize:(UIImage *)image withSize:(CGSize)newSize {
	CGFloat largestSize = (newSize.width > newSize.height) ? newSize.width : newSize.height;
	CGSize imageSize = [image size];
	
	// Scale the image while mainting the aspect and making sure the 
	// the scaled image is not smaller then the given new size. In
	// other words we calculate the aspect ratio using the largest
	// dimension from the new size and the small dimension from the
	// actual size.
	CGFloat ratio;
	if (imageSize.width > imageSize.height)
		ratio = largestSize / imageSize.height;
	else
		ratio = largestSize / imageSize.width;
	
	CGRect rect = CGRectMake(0.0, 0.0, ratio * imageSize.width, ratio * imageSize.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Crop the image to the requested new size maintaining
	// the inner most parts of the image.
	CGFloat offsetX = 0;
	CGFloat offsetY = 0;
	imageSize = [scaledImage size];
	if (imageSize.width < imageSize.height)
		offsetY = (imageSize.height / 2) - (imageSize.width / 2);
	else
		offsetX = (imageSize.width / 2) - (imageSize.height / 2);
	
	CGRect cropRect = CGRectMake(offsetX, offsetY, imageSize.width - (offsetX * 2), imageSize.height - (offsetY * 2));
	
	CGImageRef croppedImageRef = CGImageCreateWithImageInRect([scaledImage CGImage], cropRect);
	UIImage *newImage = [UIImage imageWithCGImage:croppedImageRef];
	CGImageRelease(croppedImageRef);
	
	return newImage;
}

#pragma mark Show Hide label on record count.

+(void)checkRecordAvailable:(NSMutableArray *)pArrTemp withTable:(UITableView *)pTblTemp withLabel:(UILabel *)pLabel{
    pLabel.hidden = (pArrTemp.count == 0)?NO:YES;
	[pTblTemp reloadData];
}

#pragma mark - Scrollview according to text input

+(void)scrollViewUp:(float)pUpvalue withDuration:(float)pDuration withView:(UIView *)pView{
    [UIView animateWithDuration:pDuration animations:^{
        CGRect rect = pView.frame;
        rect.origin.y -= pUpvalue;
        pView.frame = rect;
    }];
}

+(void)scrollViewDown:(float)pDownvalue withDuration:(float)pDuration withView:(UIView *)pView{
    [UIView animateWithDuration:pDuration animations:^{
        CGRect rect = pView.frame;
        rect.origin.y += pDownvalue;
        pView.frame = rect;
    }];
}

#pragma mark - Random Number

+(NSNumber*)getRandomNumber:(NSUInteger)from to:(NSUInteger)to {
	NSInteger intRandomNo = (NSInteger)from + arc4random() % (to-from+1);
	return [NSNumber numberWithInteger:intRandomNo];
}

#pragma mark - Random Inetger

+(NSInteger)getRandomInteger:(NSUInteger)from to:(NSUInteger)to {
	return (NSInteger)from + arc4random() % (to-from+1);
}

#pragma mark Call The Number 

//+(void)callTheNumber:(NSString *)pStrDialedNumber{
//	NSString *deviceName = [UIDevice currentDevice].model;    
//	if(![deviceName isEqualToString:@"iPhone"])	{
//		NSString *strAlertMessage = [NSString stringWithFormat:@"%@ 'tel:%@' %@",titleCalling,pStrDialedNumber,msgCallingAlert];
//		[Helper showAlertView:@"Alert" withMessage:strAlertMessage delegate:self];
//	}else{
//		pStrDialedNumber = [NSString stringWithFormat:@"tel://%@",pStrDialedNumber];
//		NSString *strDialedNumber = [pStrDialedNumber stringByReplacingOccurrencesOfString:@" " withString:@""];      
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strDialedNumber]];    
//	}
//}

#pragma mark - Is Valid Credit card

+(BOOL)isValidCreditCard:(NSString*)pStrCreditCard{
	BOOL isValid= NO;
	int Luhn = 0;
	for (int i=0;i<[pStrCreditCard length];i++){
		NSUInteger count = [pStrCreditCard length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
		int doubled = [[NSNumber numberWithUnsignedChar:[pStrCreditCard characterAtIndex:count-i]] intValue] - 48;
		if (i % 2)
			doubled = doubled*2;
		
		NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
		
		if ([[NSString stringWithFormat:@"%d",doubled] length] > 1){
            Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-48;
			Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-48;
		}else
			Luhn = Luhn + doubled;
	}
	if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
		isValid =  YES;
	
	return isValid;
}

#pragma mark - Add and Get Custom objects from UserDefaults

+(void)addCustomObjectToUserDefaults:(id)pObject key:(NSString *)pStrKey{
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	[currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:pObject] forKey:pStrKey];	
	[currentDefaults synchronize];	
}

+(id)getCustomObjectToUserDefaults:(NSString *)pStrKey{
	id pReturnObject;
	NSData *data = [Helper getFromNSUserDefaults:pStrKey];
	pReturnObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	return pReturnObject;
}

+(BOOL)isRetina{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)?YES:NO;
}

+(UIImage *)createImageFromView:(UITableView *)pView{
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(pView.contentSize.width, pView.contentSize.height), NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect previousFrame = pView.frame;
	pView.frame = CGRectMake(pView.frame.origin.x, pView.frame.origin.y, pView.contentSize.width, pView.contentSize.height);
	[pView.layer renderInContext:context];
	pView.frame = previousFrame;
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage *) imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)imageFromView:(UIView *)theView {
    [Helper RetinaAwareUIGraphicsBeginImageContext:theView.frame.size];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[theView.layer renderInContext:context];
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

+(void)RetinaAwareUIGraphicsBeginImageContext:(CGSize)size {
    static CGFloat scale = -1.0;
	if (scale < 0.0) {
		UIScreen *screen = [UIScreen mainScreen];
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
			scale = [screen scale];
		} else {
			scale = 0.0;
		}
	}
	if (scale > 0.0) {
		UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	} else {
		UIGraphicsBeginImageContext(size);
	}
}

+(void)goToNextTextField:(UITextField *)pTextField{
	NSInteger intNextTag = pTextField.tag +1 ;
	UIResponder *nextResponder = [pTextField.superview viewWithTag:intNextTag];
	if(nextResponder)
		[nextResponder becomeFirstResponder];
	else
		[pTextField resignFirstResponder];
}

+(void)keyboardShow:(UIView *)pTmpView andScrollView:(UIScrollView *)pTmpScrollView{
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    CGFloat keyboardHeight = 0.0;
    if(UIInterfaceOrientationIsPortrait(UIDeviceOrientationPortrait) || UIInterfaceOrientationIsPortrait(UIDeviceOrientationPortraitUpsideDown))
        keyboardHeight = 216;
    else if(UIInterfaceOrientationIsLandscape(UIDeviceOrientationLandscapeLeft) || UIInterfaceOrientationIsLandscape(UIDeviceOrientationLandscapeRight))
        keyboardHeight = 162;
    
    pTmpScrollView.frame= CGRectMake(pTmpScrollView.frame.origin.x, pTmpScrollView.frame.origin.y, pTmpScrollView.frame.size.width, mainFrame.size.height-keyboardHeight-pTmpScrollView.frame.origin.y-20);
	pTmpScrollView.contentSize = CGSizeMake(pTmpScrollView.frame.size.width, pTmpView.frame.size.height);
}

+(void)keyboardHide:(UIView *)pTmpView andScrollView:(UIScrollView *)pTmpScrollView andHeight:(CGFloat)pFltHeight{
	pTmpScrollView.frame= CGRectMake(pTmpScrollView.frame.origin.x, pTmpScrollView.frame.origin.y, pTmpScrollView.frame.size.width, pFltHeight);
	pTmpScrollView.contentSize = CGSizeMake(pTmpScrollView.frame.size.width, pTmpView.frame.size.height);
}

+(void)rateApplication:(NSString*)pStrAppID{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];

    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@%@", str,pStrAppID];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(void)openInItunes:(NSString *)pStrAppName{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms://itunes.com/apps/%@",pStrAppName]]];
}

+(NSString*)checkNullStringFromDB:(char *)pChars{
    return (pChars)?[NSString stringWithUTF8String:pChars]:@"";
}

+(void)searchNoResults:(NSArray *)pTmpArray{
    for (UIView* v in pTmpArray){
        //        if ([v isKindOfClass: [UILabel class]] && [[(UILabel*)v text] isEqualToString:@"No Results"])
        if ([v isKindOfClass: [UILabel class]]){
            [((UILabel*)v) setText:@"Data Not Found."];
            [((UILabel*)v) setHidden:NO];
            [((UILabel *)v) setFont:[UIFont fontWithName:@"Roboto-Medium" size:17.0]];
//            [((UILabel *)v) setTextColor:kPlaceholderColor];
            [((UILabel *)v) setTextColor:[UIColor whiteColor]];
            break;
        }
    }
}

@end
