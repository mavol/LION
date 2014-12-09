//
//  EditViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 6/3/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationPanelViewController.h"
#import "ObservationData.h"



@interface EditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

//What am I getting passed?
@property (nonatomic) NSString *passingSchool;
@property (nonatomic) NSString *passingDistrict;
@property (nonatomic) NSString *passingTeacher;
@property (nonatomic) NSString *passingObservation;
@property (nonatomic) ObservationData *currentObservation;
@property (nonatomic) NSMutableDictionary *passingObservations;

@end
