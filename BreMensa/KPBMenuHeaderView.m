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
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = DayLabelFont;
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
    self.backgroundColor = today ? [UIColor colorWithRed:1.000 green:0.231 blue:0.188 alpha:1] : [UIColor lightGrayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect dayLabelFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
    _dayLabel.frame = CGRectIntegral(dayLabelFrame);
    
    CGRect dateLabelFrame = CGRectMake(0.f, CGRectGetMaxY(dayLabelFrame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(dayLabelFrame));
    _dateLabel.frame = CGRectIntegral(dateLabelFrame);
}

@end
