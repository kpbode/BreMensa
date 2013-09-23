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

+ (void)initialize
{
    TitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    TextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    PriceFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    InfoFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    BackgroundImage = [[UIImage imageNamed:@"meal_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.f, 4.f, 16.f, 17.f)];
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
    
    CGSize titleSize = [title boundingRectWithSize:targetSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName : TitleFont }
                                           context:nil].size;
    
    height += titleSize.height + 10.f;
    
    CGSize textSize = [text boundingRectWithSize:targetSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName : TextFont }
                                         context:nil].size;
    
    height += textSize.height + 10.f;
    
    CGSize priceSize = [priceText boundingRectWithSize:targetSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{ NSFontAttributeName : PriceFont }
                                               context:nil].size;
    
    height += priceSize.height + 10.f;
    
    if ([infoText length] > 0) {
        CGSize infoSize = [infoText boundingRectWithSize:targetSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{ NSFontAttributeName : InfoFont }
                                                 context:nil].size;
        height += infoSize.height + 10.f;
    }
    
    return height;
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
    
    
    
    CGSize titleSize = [self.mealTitleLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{ NSFontAttributeName : self.mealTitleLabel.font }
                                                             context:nil].size;
    CGRect titleLabelFrame = CGRectMake(insetX, 10.f, titleSize.width, titleSize.height);
    self.mealTitleLabel.frame = CGRectIntegral(titleLabelFrame);
    
    
    
    CGSize mealTextSize = [self.mealTextLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{ NSFontAttributeName : self.mealTextLabel.font }
                                                                context:nil].size;
    CGRect mealTextLabelFrame = CGRectMake(insetX, CGRectGetMaxY(titleLabelFrame) + 10.f, mealTextSize.width, mealTextSize.height);
    self.mealTextLabel.frame = CGRectIntegral(mealTextLabelFrame);
    
    
    CGSize priceSize = [self.priceTextLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{ NSFontAttributeName : self.priceTextLabel.font }
                                                              context:nil].size;
    CGRect priceLabelFrame = CGRectMake(insetX, CGRectGetMaxY(mealTextLabelFrame) + 10.f, priceSize.width, priceSize.height);
    self.priceTextLabel.frame = CGRectIntegral(priceLabelFrame);
    
    
    CGSize infoSize = [self.infoTextLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName : self.infoTextLabel.font }
                                                            context:nil].size;
    CGRect infoLabelFrame = CGRectMake(insetX, CGRectGetMaxY(priceLabelFrame) + 10.f, infoSize.width, infoSize.height);
    self.infoTextLabel.frame = CGRectIntegral(infoLabelFrame);
}

@end
