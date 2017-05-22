//
//  HistoryVC.h
//  UberforX Provider
//
//  Created by My Mac on 11/15/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"

@interface HistoryVC : BaseVC <UITableViewDataSource,UITableViewDelegate>
{
    BOOL from;
    
    NSDictionary *passHistory;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

//////////// Outlets Price Label

@property (weak, nonatomic) IBOutlet UIImageView *imgNoDisplay;

////////////
- (IBAction)btnFromDatePressed:(id)sender;
- (IBAction)btnToDatePressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
- (IBAction)btnSearchHistoryPressed:(id)sender;
- (IBAction)btnSharePressed:(id)sender;
- (IBAction)btnNavBackPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewForDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *historyPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnFrom;
@property (weak, nonatomic) IBOutlet UIButton *btnTo;
@property (weak, nonatomic) IBOutlet UILabel *lblBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;

@end
