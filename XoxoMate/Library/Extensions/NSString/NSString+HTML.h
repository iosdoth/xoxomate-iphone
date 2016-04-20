//
//  NSString+HTML.h
//  Vetted-Intl
//
//  Created by Manish on 19/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (HTML)

// Instance Methods
- (NSString *)stringByConvertingHTMLToPlainText;
- (NSString *)stringByDecodingHTMLEntities;
- (NSString *)stringByEncodingHTMLEntities;
- (NSString *)stringWithNewLinesAsBRs;
- (NSString *)stringByRemovingNewLinesAndWhitespace;
- (NSString *)stringByLinkifyingURLs;

// DEPRECIATED - Please use NSString stringByConvertingHTMLToPlainText
- (NSString *)stringByStrippingTags __attribute__((deprecated));

-(NSString*)unescapeHtmlCodes;
- (NSString *)stringByEncodingHTMLEntities:(BOOL)isUnicode;
@end
