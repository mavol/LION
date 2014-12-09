//
//  ObservationReviewViewController.h
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/23/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationData.h"
#import "EditViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "ObservationTableViewController.h"
#import "XYPieChart.h"
#import "CHCSVParser.h"
#import <CoreText/CoreText.h>
#import <MessageUI/MFMailComposeViewController.h>




@interface ObservationReviewViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate, CPTPlotDataSource, CPTPlotDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) NSArray        *sliceColors;
@property(nonatomic, strong) NSArray        *sliceColorsDim;
@property(nonatomic, strong) UIPopoverController *popover;
@property(nonatomic, strong) UIViewController *infoViewController;



//What am I getting passed?
@property (nonatomic) NSString *passingSchool;
@property (nonatomic) NSString *passingDistrict;
@property (nonatomic) NSString *passingTeacher;
@property (nonatomic) NSString *passingObservation;
@property (nonatomic) ObservationData *currentObservation;
@property (nonatomic) NSMutableDictionary *passingObservations;

@end


//CPTPieChartDataSource, CPTPieChartDelegate,