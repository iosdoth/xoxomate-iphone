
#import "UIViewController+Additions.h"

static int kBackgroundViewTag = 42;

@implementation UIViewController (Additions)

- (void)addCommonBackground {
    UIImage *background = [UIImage imageNamed:@"main_bg"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    backgroundView.tag = kBackgroundViewTag;
    backgroundView.image = background;
    
    if ([self isKindOfClass: [UITableViewController class]]) {
        ((UITableViewController *)self).tableView.backgroundView = backgroundView;
    } else {
        [self.view addSubview: backgroundView];
        [self.view sendSubviewToBack: backgroundView];
    }
    [self setTopHeaderColor];
}

- (void)removeCommonBackground {
    UIView *background = [self.view viewWithTag: kBackgroundViewTag];
    if (background) {
        [background removeFromSuperview];
    }
}

- (void)addNotidicationBadgeObserver{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge) name:@"NotificationBadgeObserver" object:nil];
#pragma clang diagnostic pop
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationBadgeObserver" object:nil];
}

- (void)setTopHeaderColor{
    [self.view viewWithTag:101].backgroundColor = [UIColor colorWithRed:255.0/255.0 green:129.0/255.0 blue:60.0/255.0 alpha:1.0];
}

@end
