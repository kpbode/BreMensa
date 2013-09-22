#import "KPBMealplanInfoView.h"

@interface KPBMealplanInfoView ()

@property (nonatomic, weak, readwrite) UILabel *textLabel;

@end

@implementation KPBMealplanInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10.f, 0.f)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.f];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.adjustsFontSizeToFitWidth = NO;
        
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
    }
    return self;
}

@end
