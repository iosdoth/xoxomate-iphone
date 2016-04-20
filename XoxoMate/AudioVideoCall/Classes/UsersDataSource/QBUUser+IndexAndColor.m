//
// Created by Anton Sokolchenko on 9/28/15.
// Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QBUUser+IndexAndColor.h"
#import "UsersDataSourceCall.h"


@implementation QBUUser (IndexAndColor)

- (NSUInteger)index {

    NSUInteger idx = [UsersDataSourceCall.instance indexOfUser:self];
    return idx;
}

- (UIColor *)color {

    UIColor *color = [UsersDataSourceCall.instance colorAtUser:self];
    return color;
}

@end