//
//  NSString+extras.h
//  iPhoneBasicStructure
//
//  Created by _MyCompanyName_ on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (extras)

-(NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set;
-(NSString *)trimWhiteSpace;
-(NSString *)stripHTML;

//Validation for empty/email/url
-(BOOL)isEmptyString ;
-(BOOL)isValidEmail;
-(BOOL)isValidURL;

//Common Custom encryption for all platform
-(NSString *)implodeArray:(NSMutableArray *)pArr withString:(NSString *)pStrGlueString;

//Date Conversion
-(NSString *)convertToDateFormat:(NSString *)pFromDateFormat ToDateFormat:(NSString *)pToDateFormat;

//Convert string to URL
-(NSURL*)toURL;

//starts/ends-with compare/escaping/count substring
- (BOOL)startsWithString:(NSString*)otherString;
- (BOOL)endsWithString:(NSString*)otherString;
- (NSComparisonResult)compareCaseInsensitive:(NSString*)other;
- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters;
- (NSString*)stringByEscapingURL;
- (NSString*)stringByUnescapingURL;
- (BOOL) containsString:(NSString *)aString;
- (BOOL) containsString:(NSString *)aString ignoringCase:(BOOL)flag;
- (NSInteger)countSubstring:(NSString *)aString ignoringCase:(BOOL)flag;

//Date Compare
//-(BOOL)isGreaterToDate:(NSString *)pStrToDate;
//-(CGFloat)getHoursFromDate:(NSString *)pStrDateTime;

//NSString to NSURL
-(NSURL *)toWebURL;

//MD5
- (NSString *) stringFromMD5;

- (NSString *)urlencode;
- (BOOL)isNumeric;

//- (NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index;
-(NSString*)stringByAddingSpace:(NSInteger)spaceCount atIndex:(NSInteger)index;

//- (NSString *)documentDirectory;
- (void)createFolder;

//-(NSString *)fullPath;
- (float)expectedHeight:(UIFont*)font maxSize:(CGSize)size;
- (float)expectedWidth:(UIFont*)font maxSize:(CGSize)size;
- (CGSize)expectedSize:(UIFont*)font maxSize:(CGSize)size;
@end
