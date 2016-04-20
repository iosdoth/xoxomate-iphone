//
//  UILabel+extras.m
//  TravelApp
//
//  Created by Manish Dudharejia on 31/10/14.
//  Copyright (c) 2014 E2M. All rights reserved.
//

#import "UILabel+extras.h"

@implementation UILabel (extras)

-(float)expectedHeight:(UIFont*)font {
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByCharWrapping];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                      attributes:attributesDictionary
                                                         context:nil];
    CGSize *expectedLabelSize = &expectedLabelRect.size;
    return expectedLabelSize->height;
}


- (void)jaq_setHTMLFromString:(NSString *)string {
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<span style = body{font-family: Roboto-Regular; font-size: 17px;}</span>"]];
    self.attributedText = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                documentAttributes:nil
                                                             error:nil];
    
}

@end
