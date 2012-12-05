//
//  KPBMensaDetailView.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMensaDetailView.h"

@interface KPBMensaDetailView ()

@property (nonatomic, weak, readwrite) MKMapView *mapView;
@property (nonatomic, weak, readwrite) UIImageView *shadowView;
@property (nonatomic, weak, readwrite) UILabel *openingTimesLabel;
@property (nonatomic, weak, readwrite) UITableView *tableView;

@end

@implementation KPBMensaDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        mapView.layer.borderColor = [[UIColor grayColor] CGColor];
        mapView.layer.borderWidth = 1.f;
        mapView.layer.cornerRadius = 7.f;
        
        [self addSubview:mapView];
        self.mapView = mapView;
        
        UIImage *shadowImage = [[UIImage imageNamed:@"details_shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f)];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
        
        [self addSubview:shadowView];
        self.shadowView = shadowView;
        
        UILabel *openingTimesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        openingTimesLabel.text = @"Öffnungszeiten";
        openingTimesLabel.backgroundColor = [UIColor clearColor];
        openingTimesLabel.textColor = [UIColor darkGrayColor];
        openingTimesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
        [self addSubview:openingTimesLabel];
        self.openingTimesLabel = openingTimesLabel;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [self addSubview:tableView];
        self.tableView = tableView;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect mapViewFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
    self.mapView.frame = CGRectInset(mapViewFrame, 10.f, 10.f);
    
    self.shadowView.frame = CGRectMake(0.f, CGRectGetMaxY(self.mapView.frame) + 10.f, CGRectGetWidth(self.bounds), 23.f);
    
    self.openingTimesLabel.frame = CGRectMake(10.f, CGRectGetMaxY(self.shadowView.frame), CGRectGetWidth(self.bounds) - 20.f, 20.f);
    
    CGRect tableViewFrame = CGRectMake(0.f, CGRectGetMaxY(self.openingTimesLabel.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.openingTimesLabel.frame));
    
    self.tableView.frame = UIEdgeInsetsInsetRect(tableViewFrame, UIEdgeInsetsMake(10.f, 10.f, 0.f, 10.f));
}

@end
