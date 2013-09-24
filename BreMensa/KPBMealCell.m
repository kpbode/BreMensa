#import "KPBMealCell.h"

@interface KPBMealCell ()

@property (nonatomic, weak, readwrite) UILabel *mealTitleLabel;
@property (nonatomic, weak, readwrite) UILabel *mealTextLabel;
@property (nonatomic, weak, readwrite) UILabel *priceTextLabel;
@property (nonatomic, weak, readwrite) UILabel *infoTextLabel;

@end

@implementation KPBMealCell

static UIFont *TitleFont;
static UIFont *TextFont;
static UIFont *PriceFont;
static UIFont *InfoFont;
static UIImage *BackgroundImage;
static NSCache *textSizeCache;

+ (void)setupFonts
{
    TitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    TextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    PriceFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    InfoFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (void)initialize
{
    textSizeCache = [[NSCache alloc] init];
    [[self class] setupFonts];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [textSizeCache removeAllObjects];
        [[self class] setupFonts];
    }];
}

+ (CGFloat)heightForWidth:(CGFloat)width
                    title:(NSString *)title
                     text:(NSString *)text
                priceText:(NSString *)priceText
              andInfoText:(NSString *)infoText
{
    
    CGFloat targetWidth = width - 20.f;
    
    CGFloat height = 10.f;
    
    CGSize targetSize = CGSizeMake(targetWidth, CGFLOAT_MAX);
    
    CGSize titleSize = [[self class] sizeForText:title
                                        withFont:TitleFont
                                 andBoundingSize:targetSize];
    height += titleSize.height + 10.f;
    
    CGSize textSize = [[self class] sizeForText:text
                                       withFont:TextFont
                                andBoundingSize:targetSize];
    height += textSize.height + 10.f;
    
    CGSize priceSize = [[self class] sizeForText:priceText
                                        withFont:PriceFont
                                 andBoundingSize:targetSize];
    height += priceSize.height + 10.f;
    
    if ([infoText length] > 0) {
        CGSize infoSize = [[self class] sizeForText:infoText
                                           withFont:InfoFont
                                    andBoundingSize:targetSize];
        height += infoSize.height + 10.f;
    }
    
    return height;
}

+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font andBoundingSize:(CGSize)boundingSize
{
    NSString *cacheKey = [NSString stringWithFormat:@"%@|%@|%f,%@", text, font.fontName, font.pointSize, NSStringFromCGSize(boundingSize)];
    NSValue *sizeValue = [textSizeCache objectForKey:cacheKey];
    if (sizeValue != nil) return [sizeValue CGSizeValue];
    
    CGSize textSize = [text boundingRectWithSize:boundingSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName : font }
                                         context:nil].size;
    
    sizeValue = [NSValue valueWithCGSize:textSize];
    [textSizeCache setObject:sizeValue forKey:cacheKey];
    
    return textSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
        
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 0.f;
        
        UILabel *mealTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mealTitleLabel.backgroundColor = [UIColor clearColor];
        mealTitleLabel.font = TitleFont;
        
        [self.contentView addSubview:mealTitleLabel];
        self.mealTitleLabel = mealTitleLabel;
        
        UILabel *mealTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mealTextLabel.backgroundColor = [UIColor clearColor];
        mealTextLabel.numberOfLines = 0;
        mealTextLabel.font = TextFont;
        
        [self.contentView addSubview:mealTextLabel];
        self.mealTextLabel = mealTextLabel;
        
        UILabel *priceTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceTextLabel.backgroundColor = [UIColor clearColor];
        priceTextLabel.numberOfLines = 0;
        priceTextLabel.font = PriceFont;
        
        [self.contentView addSubview:priceTextLabel];
        self.priceTextLabel = priceTextLabel;
        
        
        UILabel *infoTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoTextLabel.backgroundColor = [UIColor clearColor];
        infoTextLabel.numberOfLines = 0;
        infoTextLabel.font = InfoFont;
        
        [self.contentView addSubview:infoTextLabel];
        self.infoTextLabel = infoTextLabel;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds) - 20.f;
    
    CGFloat insetX = 10.f;
    
    CGSize titleSize = [[self class] sizeForText:self.mealTitleLabel.text
                                        withFont:self.mealTitleLabel.font
                                 andBoundingSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGRect titleLabelFrame = CGRectMake(insetX, 10.f, titleSize.width, titleSize.height);
    self.mealTitleLabel.frame = CGRectIntegral(titleLabelFrame);
    
    CGSize mealTextSize = [[self class] sizeForText:self.mealTextLabel.text
                                           withFont:self.mealTextLabel.font
                                    andBoundingSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGRect mealTextLabelFrame = CGRectMake(insetX, CGRectGetMaxY(titleLabelFrame) + 10.f, mealTextSize.width, mealTextSize.height);
    self.mealTextLabel.frame = CGRectIntegral(mealTextLabelFrame);
    
    
    CGSize priceSize = [[self class] sizeForText:self.priceTextLabel.text
                                        withFont:self.priceTextLabel.font
                                 andBoundingSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGRect priceLabelFrame = CGRectMake(insetX, CGRectGetMaxY(mealTextLabelFrame) + 10.f, priceSize.width, priceSize.height);
    self.priceTextLabel.frame = CGRectIntegral(priceLabelFrame);
    
    
    CGSize infoSize = [[self class] sizeForText:self.infoTextLabel.text
                                       withFont:self.infoTextLabel.font
                                andBoundingSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGRect infoLabelFrame = CGRectMake(insetX, CGRectGetMaxY(priceLabelFrame) + 10.f, infoSize.width, infoSize.height);
    self.infoTextLabel.frame = CGRectIntegral(infoLabelFrame);
}

@end
