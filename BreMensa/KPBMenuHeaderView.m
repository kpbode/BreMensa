#import "KPBMenuHeaderView.h"

@interface KPBMenuHeaderView ()

@property (nonatomic, weak, readwrite) UILabel *dayLabel;
@property (nonatomic, weak, readwrite) UILabel *dateLabel;

@end

@implementation KPBMenuHeaderView

static UIFont *DayLabelFont;
static UIFont *DateLabelFont;

+ (void)initialize
{
    DayLabelFont = [UIFont systemFontOfSize:18.f];
    DateLabelFont = [UIFont italicSystemFontOfSize:14.f];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        CGRect dayLabelFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = DayLabelFont;
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
        CGRect dateLabelFrame = CGRectMake(0.f, CGRectGetMaxY(dayLabelFrame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(dayLabelFrame));
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = DateLabelFont;
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
    }
    return self;
}

- (void)setupBackgroundForToday:(BOOL)today
{
    self.backgroundColor = today ? [UIColor blackColor] : [UIColor darkGrayColor];
}

@end
