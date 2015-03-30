//
//  AddNewViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/22/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationData.h"
#import "ObservationPanelViewController.h"
#import "DistrictTableViewController.h"



@interface AddNewViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

//What am I getting passed?
@property (nonatomic) NSString * passingDistrict;
@property (nonatomic) NSString * passingSchool;
@property (nonatomic) NSString * passingTeacher;
@property (nonatomic) NSMutableDictionary *passingObservations;
@property (nonatomic) NSString *passingNumStudents;
@property (nonatomic) NSString *passingObserverName;





@end
