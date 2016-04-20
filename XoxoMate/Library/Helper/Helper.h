//
//  Helper.h
//  iPhoneBasicStructure
//
//  Created by _MyCompanyName_ on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TKAlertCenter.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}
static inline double degrees (double radians) {return radians * 180/M_PI;}

@interface Helper : NSObject

//Custom AlertView
+(void)showAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage delegate:(id)pDelegate;
+(void)showYesNoAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage tag:(NSInteger)pTag delegate:(id)pDelegate;
+(void)showInAppAlertView:(NSString *)pstrTitle withMessage:(NSString *)pstrMessage tag:(NSInteger)pTag delegate:(id)pDelegate;
+ (void)siAlertView:(NSString*)title msg:(NSString*)msg;
+(void)registerKeyboardNotification:(id)pObserver;
+(void)deRegisterKeyboardNotification:(id)pObserver;

//Address From LatLong
//+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude;

//String function
+(NSString*)getStringFromDate:(NSDate*)pDate withFormat:(NSString*)pDateFormat;
+(NSDate*)getDateFromString:(NSString*)pStrDate withFormat:(NSString*)pDateFormat;
+(NSString*)dateStringFromString:(NSString *)dateToConver format:(NSString *)fromFormat toFormat:(NSString *)toFormat;
//+(NSMutableString*)getRandomString:(NSInteger)pIntLength;

//NSUserDefaults
+(void)addToNSUserDefaults:(id)pObject forKey:(NSString*)pForKey;
+(void)removeFromNSUserDefaults:(NSString*)pForKey;
+(id)getFromNSUserDefaults:(NSString*)pForKey;

+(void)addBoolToUserDefaults:(BOOL)pBool forKey:(NSString *)pForKey;
+(BOOL)getBoolFromUserDefaults:(NSString*)pForKey;

+ (void)addIntToUserDefaults:(NSInteger)tag forKey:(NSString*)pForKey;
+ (NSInteger)getIntFromNSUserDefaults:(NSString*)pForKey;

//Local Notification
//+(void)setLocalNotification:(NSString *)pStrNotificationTitle;
//+(void)setLocalNotificationWithDate:(NSDate *)pDateTime withNotificationTitle:(NSString *)pStrNotificationTitle;
//+(void)removeLocalNotificationIfSet:(NSString *)pStrNotificationTitle;

//DocumentDirectory Path
+(NSString*)getDocumentDirectoryPath:(NSString*)pStrPathName;

//Camera Availability
+(UIImagePickerControllerCameraDevice)getAvailableCamera;
+(void)showCamera:(id)pController;
+(void)showPhotoLibrary:(id)pController;
+(BOOL)isCameraDeviceAvailable;
+(BOOL)isFrontCameraDeviceAvailable;
+(BOOL)isRearCameraDeviceAvailable;

//Image resize
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIImage *)imageScaleAndCropToMaxSize:(UIImage *)image withSize:(CGSize)newSize;

//Scroll view updown for textfield show properly
+(void)scrollViewUp:(float)pUpvalue withDuration:(float)pDuration withView:(UIView *)pView;
+(void)scrollViewDown:(float)pDownvalue withDuration:(float)pDuration withView:(UIView *)pView;

//Show hide label on record countl
+(void)checkRecordAvailable:(NSMutableArray *)pArrTemp withTable:(UITableView *)pTblTemp withLabel:(UILabel *)pLabel;

//Random Number
+(NSNumber*)getRandomNumber:(NSUInteger)from to:(NSUInteger)to;

//Random Integer
+(NSInteger)getRandomInteger:(NSUInteger)from to:(NSUInteger)to;

//Call Number
//+(void)callTheNumber:(NSString *)pStrDialedNumber;

+(BOOL)isValidCreditCard:(NSString*)pStrCreditCard;

//Add and Get Custom objects from UserDefaults
+(void)addCustomObjectToUserDefaults:(id)pObject key:(NSString *)pStrKey;
+(id)getCustomObjectToUserDefaults:(NSString *)pStrKey;

+(BOOL)isRetina;

+(UIImage *)createImageFromView:(UITableView *)pView;

//For Image From View
+(UIImage *)imageWithView:(UIView *)view;
+(UIImage *)imageFromView:(UIView *)theView;
+(void)RetinaAwareUIGraphicsBeginImageContext:(CGSize)size;

+(void)goToNextTextField:(UITextField *)pTextField;

+(void)keyboardShow:(UIView *)pTmpView andScrollView:(UIScrollView *)pTmpScrollView;
+(void)keyboardHide:(UIView *)pTmpView andScrollView:(UIScrollView *)pTmpScrollView andHeight:(CGFloat)pFltHeight;

+(void)rateApplication:(NSString*)pStrAppID;
+(void)openInItunes:(NSString *)pStrAppName;

+(NSString*)checkNullStringFromDB:(char *)pChars;

+(void)searchNoResults:(NSArray *)pTmpArray;

@end
