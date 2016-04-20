//
//  NSString+extras.m
//  iPhoneBasicStructure
//
//  Created by _MyCompanyName_ on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+extras.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (extras)

- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set{
	NSRange r = [self rangeOfCharacterFromSet:set];
	if (r.location == NSNotFound) return self;
	NSMutableString *newString = [self mutableCopy];
	do{
		[newString replaceCharactersInRange:r withString:subs];
		r = [newString rangeOfCharacterFromSet:set];
	}while (r.location != NSNotFound);
	return newString;
}

- (NSString *) trimWhiteSpace {
	NSMutableString *s = [self mutableCopy];
	CFStringTrimWhitespace ((CFMutableStringRef) s);
	return (NSString *) [s copy];
}

-(NSString *)stripHTML {
	NSUInteger len = [self length];
	NSMutableString *s = [NSMutableString stringWithCapacity: len];
	NSUInteger i = 0, level = 0;
	
	for (i = 0; i < len; i++) {
		NSString *ch = [self substringWithRange: NSMakeRange (i, 1)];
		if ([ch isEqualToString: @"<"])
			level++;
		else if ([ch isEqualToString: @">"]) {
			level--;
			if (level == 0)
				[s appendString: @" "];
		}else if (level == 0)
			[s appendString: ch];
	}
	
	return (NSString *) [s copy];
}

#pragma mark - Validation empty/email/url

- (BOOL)isEmptyString {
	NSString *copy;
	if (self == nil)
		return (YES);
	if ([self isEqualToString:@""])
		return (YES);
	
	copy = [self copy];
	if ([[copy trimWhiteSpace] isEqualToString: @""])
		return (YES);
	
	return (NO);
}

-(BOOL)isValidEmail{
	BOOL stricterFilter = YES;

	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidURL{
	BOOL isValidURL = NO;	
	NSURL *candidateURL = [NSURL URLWithString:self];
	if (candidateURL && candidateURL.scheme && candidateURL.host)
		isValidURL = YES;
	return isValidURL;
}

-(NSString *)implodeArray:(NSMutableArray *)pArr withString:(NSString *)pStrGlueString{
	NSString *strOutput = @"";
	if ([pArr count] > 0){
		NSString *str = @"";
		str = [str stringByAppendingString:[pArr objectAtIndex:0]];
		for (int i =1 ; i < [pArr count]; i++) {
			str = [str stringByAppendingString:pStrGlueString];
			str = [str stringByAppendingString:[pArr objectAtIndex:i]];
		}
		strOutput = str;
	}
	return strOutput;
}

//Format Conversion
-(NSString *)convertToDateFormat:(NSString *)pFromDateFormat ToDateFormat:(NSString *)pToDateFormat{
	NSDateFormatter *dtFormatter = [[NSDateFormatter alloc]init];
	[dtFormatter setDateFormat:pFromDateFormat];
	NSDate *date = [dtFormatter dateFromString:self];
	[dtFormatter setDateFormat:pToDateFormat];
	return [dtFormatter stringFromDate:date];
}

//Convert string url to NSURL
-(NSURL*)toURL{
	return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

//Compare
-(BOOL)startsWithString:(NSString*)otherString {
    return [self rangeOfString:otherString].location == 0;
}

-(BOOL)endsWithString:(NSString*)otherString {
    return [self rangeOfString:otherString].location == [self length]-[otherString length];
}

-(NSComparisonResult)compareCaseInsensitive:(NSString*)other {
    NSString *selfString = [self lowercaseString];
    NSString *otherString = [other lowercaseString];	
    return [selfString compare:otherString];
}

- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters {
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)characters, kCFStringEncodingUTF8);
}

- (NSString*)stringByEscapingURL {
    return [self stringByPercentEscapingCharacters:@";/?:@&=+$,"];
}

- (NSString*)stringByUnescapingURL {
    return (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, CFSTR(""));
}

- (BOOL)containsString:(NSString *)aString {
    return [self containsString:aString ignoringCase:NO];
}

- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    return [self rangeOfString:aString options:mask].length > 0;
}

- (NSInteger)countSubstring:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    return [self rangeOfString:aString options:mask].length;
}

#pragma mark - Date functions

//-(BOOL)isGreaterToDate:(NSString *)pStrToDate{
//	BOOL boolISGreater=NO;
//	NSDate *dateFrom = [Helper getDateFromString:self withFormat:kDateFormat];
//	NSDate *dateTo = [Helper getDateFromString:pStrToDate withFormat:kDateFormat];
//	NSComparisonResult result = [dateFrom compare:dateTo];
//	if(result==NSOrderedDescending)
//		boolISGreater = YES;
//	return boolISGreater;
//}
//
//-(CGFloat)getHoursFromDate:(NSString *)pStrDateTime{
//	NSDate *date = [Helper getDateFromString:pStrDateTime withFormat:kDateFormat];	
//	double dtDiffInHours = [[NSDate date] timeIntervalSinceDate:date]/3600;
//	NSLog(@"Hours Difference ==> %f",dtDiffInHours);
//	return dtDiffInHours;
//}

#pragma mark - NSString to NSURL

-(NSURL *)toWebURL{
	NSURL *webURL = nil;
	if([self hasPrefix:@"http"])
		webURL = [NSURL URLWithString:self];
	else 
		webURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self]];
	
	return webURL;
}

#pragma mark - MD5

- (NSString *) stringFromMD5{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (NSString *)urlencode {
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
}

- (BOOL)isNumeric{
    static NSCharacterSet *csetNonDigits = nil;
    if (!csetNonDigits) {
        csetNonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    }
    return ([self rangeOfCharacterFromSet:csetNonDigits].location == NSNotFound);
}

//- (NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index{
//    NSString *result = [NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0],stringToAddSpace];
//    return result;
//}

-(NSString*)stringByAddingSpace:(NSInteger)spaceCount atIndex:(NSInteger)index{
    NSString *result = [NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0],self];
    return result;
}

- (void)createFolder{
    NSString *dataPath = @"";//[self documentDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (float)expectedHeight:(UIFont*)font maxSize:(CGSize)size{
    NSDictionary *attributesDictionary = @{NSFontAttributeName:font};
    CGRect expectedLabelRect = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSLineBreakByWordWrapping)
                                                                  attributes:attributesDictionary
                                                                     context:nil];
    CGSize maxSize = expectedLabelRect.size;
    return maxSize.height;
}

- (float)expectedWidth:(UIFont*)font maxSize:(CGSize)size{
    NSDictionary *attributesDictionary = @{NSFontAttributeName:font};
    CGRect expectedLabelRect = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSLineBreakByWordWrapping)
                                               attributes:attributesDictionary
                                                  context:nil];
    CGSize maxSize = expectedLabelRect.size;
    return maxSize.width;
}

- (CGSize)expectedSize:(UIFont*)font maxSize:(CGSize)size{
    NSDictionary *attributesDictionary = @{NSFontAttributeName:font};
    CGRect expectedLabelRect = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSLineBreakByWordWrapping)
                                               attributes:attributesDictionary
                                                  context:nil];
    CGSize maxSize = expectedLabelRect.size;
    return maxSize;
}

@end
