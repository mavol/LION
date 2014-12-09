//
//  ObservationData.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ObservationData : NSObject


//What am I getting passed?
@property (nonatomic) NSString *districtName;
@property (nonatomic) NSString *schoolName;
@property (nonatomic) NSString *teacherName;
@property (nonatomic) NSString *grade;
@property (nonatomic) NSString *numStudents;
@property (nonatomic) NSString *observerName;
@property (nonatomic) NSMutableDictionary *activityNotes;
@property (nonatomic) NSMutableArray *events;
@property (nonatomic) NSMutableDictionary *activities;
@property (nonatomic) NSDate *observationDate;
@property (nonatomic) NSString *prereviewSummary;
@property (nonatomic) NSString *postreviewSummary;
@property (nonatomic) NSNumber *prereviewRating;
@property (nonatomic) NSNumber *postreviewRating;


@end
