//
//  KPBMensaDetailViewController.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMensaDetailViewController.h"
#import "KPBMensaDetailView.h"

@interface KPBMensaDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readwrite) KPBMensa *mensa;
@property (nonatomic, weak, readwrite) KPBMensaDetailView *mensaView;

@end

@implementation KPBMensaDetailViewController

- (id)initWithMensa:(KPBMensa *)mensa
{
    self = [super init];
    if (self) {
        self.mensa = mensa;
        self.title = mensa.name;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    KPBMensaDetailView *detailView = [[KPBMensaDetailView alloc] initWithFrame:CGRectZero];
    
    detailView.tableView.dataSource = self;
    detailView.tableView.delegate = self;
    
    self.view = detailView;
    self.mensaView = detailView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OpenTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
