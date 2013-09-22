#import <UIKit/UIKit.h>

@interface KPBMealCell : UICollectionViewCell

+ (CGFloat)heightForWidth:(CGFloat)width title:(NSString *)title text:(NSString *)text priceText:(NSString *)priceText andInfoText:(NSString *)infoText;

@property (nonatomic, weak, readonly) UILabel *mealTitleLabel;
@property (nonatomic, weak, readonly) UILabel *mealTextLabel;
@property (nonatomic, weak, readonly) UILabel *priceTextLabel;
@property (nonatomic, weak, readonly) UILabel *infoTextLabel;

@end
