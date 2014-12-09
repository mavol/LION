//
//  SchoolTableViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationData.h"
#import "TeacherTableViewController.h"
#import "AddNewViewController.h"
#import "DistrictTableViewController.h"


@interface SchoolTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


//What am I getting passed?
@property (nonatomic) NSString *passingDistrict;
@property (nonatomic) NSString * passingTeacher;
@property (nonatomic) ObservationData *currentObservation;
@property (nonatomic) NSMutableDictionary *passingObservations;


@end
