//
//  UILabel+extras.h
//  TravelApp
//
//  Created by Manish Dudharejia on 31/10/14.
//  Copyright (c) 2014 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extras)

-(float)expectedHeight:(UIFont*)font;
- (void)jaq_setHTMLFromString:(NSString *)string;

@end
