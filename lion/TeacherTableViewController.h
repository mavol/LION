//
//  TeacherTableViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewViewController.h"
#import "ObservationData.h"
#import "ObservationTableViewController.h"


@interface TeacherTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


//What am I getting passed?
@property (nonatomic) ObservationData *currentObservationData;
@property (nonatomic) NSString *passingSchool;
@property (nonatomic) NSString *passingDistrict;
@property (nonatomic) NSMutableDictionary *passingObservations;


@end
