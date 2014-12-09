//
//  DistrictTableViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolTableViewController.h"
#import "AddNewViewController.h"
#import "ObservationData.h"

@interface DistrictTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

//What am I getting passed?
@property (nonatomic) ObservationData *currentObservation;
@property (nonatomic) NSMutableDictionary *passingObservations;


@end
