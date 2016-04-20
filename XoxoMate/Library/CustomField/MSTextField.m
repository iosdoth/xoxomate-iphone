//
//  MSTextField.m
//  BasicStructure
//
//  Created by Marvin on 31/08/13.
//  Copyright (c) 2013 MFMA. All rights reserved.
//

#import "MSTextField.h"

@implementation MSTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib{
    //self.backgroundColor = [UIColor whiteColor];
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds ,10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds ,10, 0);
}

@end
