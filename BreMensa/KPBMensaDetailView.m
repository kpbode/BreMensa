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
@property (nonatomic, weak, readwrite) UITableView *tableView;

@end

@implementation KPBMensaDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:mapView];
        self.mapView = mapView;
        
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
    
    self.mapView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
    
    self.tableView.frame = CGRectMake(0.f, CGRectGetMaxY(self.mapView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.mapView.frame));
}

@end
