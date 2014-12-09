//
//  ObservationPanelViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/23/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationData.h"
#import "AddNewViewController.h"
#import "ObservationReviewViewController.h"
#import "EditViewController.h"

@interface ObservationPanelViewController : UIViewController {
  
}



//What am I getting passed?
@property (nonatomic) NSString *passingSchool;
@property (nonatomic) NSString *passingDistrict;
@property (nonatomic) NSString *passingTeacher;
@property (nonatomic) NSString *passingGrade;
@property (nonatomic) NSString *passingObserverName;
@property (nonatomic) NSString *passingNumStudents;
@property (nonatomic) NSMutableDictionary *passingObservations;


@end
