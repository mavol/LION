//
//  ObservationReviewViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/23/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "ObservationReviewViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ObservationReviewViewController () {
    
    NSMutableDictionary *events;
    NSMutableDictionary *eventGaps;
    NSMutableDictionary *imgDictPDF;
    NSMutableArray *flowEventTips;
    NSMutableArray *flowEventsBases;
    NSMutableArray *flowTitles;
    NSMutableArray *dimCountedArray;
    NSArray *allDimFields;
    NSArray *customTickLocations;
    NSMutableDictionary *dimValues;
    NSMutableDictionary *dimTitles;
    NSUInteger count;
    NSDate *start;
    NSDate *end;
    NSMutableDictionary *dimCounted;
    NSMutableArray *dimOrderedTitles;
    NSMutableDictionary *dimCombinedEvents;
    NSMutableArray *scatterAverage;
//    NSMutableArray *scatterMin;
//    NSMutableArray *scatterMax;
    float totalClassLength;
    int totalLength;
    ObservationData *thisObservation;
    CPTScatterPlot *sPlot;
//    CPTRangePlot *rPlot;
    CPTBarPlot *flowPlot;
    CPTXYGraph *graph;
    CPTPieChart *timePieCPT;
    CPTPieChart *activityPieCPT;
    NSString *pdfFileName;
    NSString *tempFileName;
    float upsizer;
    }



@property (strong, nonatomic) IBOutlet XYPieChart *dimAActivityChart;
@property (strong, nonatomic) IBOutlet XYPieChart *dimATimeChart;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabelActivity;
@property  (nonatomic) IBOutlet UISegmentedControl *dimSwitcherControl;
@property (weak, nonatomic) IBOutlet UISwitch *observerGapSwitch;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *corePlotHostingView;
@property (weak, nonatomic) IBOutlet UISwitch *flowViewSwitch;
@property (weak, nonatomic) IBOutlet UIView *postReviewView;
@property (weak, nonatomic) IBOutlet UISlider *postreviewRating;
@property (weak, nonatomic) IBOutlet UITextView *postreviewSummary;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *timePieCPTHostingView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *activityPieCPTHostingView;

@end

@implementation ObservationReviewViewController

//sends csv via email
- (IBAction)sendRaw:(id)sender {
    if (thisObservation.postreviewSummary) {
        [self MakeCSV];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"First you must update summary statement and rating after having viewed the observation data." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [self editSummaryAndRating:sender];
    }
}

//checks to make sure the user has viewed all the data screens and the there's a post review summary, if so, calls [self drawPDF];
- (IBAction)sendPDF:(id)sender {
    if (thisObservation.postreviewSummary) {
        [self drawPDF];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"First you must update summary statement and rating after having viewed the observation data." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [self editSummaryAndRating:sender];
    }
}

//transitions to DistrictTableViewController if postReviewSummary exists.
- (IBAction)done:(id)sender {
    if (thisObservation.postreviewSummary) {
        [self performSegueWithIdentifier:@"observationReviewToDistrict" sender:self];
    }
}

//touching outside any text box dismisses keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)editSummaryAndRating:(id)sender {
//    [self.view resignFirstResponder];
    self.postreviewSummary.layer.borderWidth = 1.0f;
    self.postreviewSummary.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.postreviewSummary.layer.cornerRadius = 5.0f;
    self.postReviewView.layer.cornerRadius = 5.0f;
    if (self.postreviewSummary.text) {
        self.postreviewSummary.text = thisObservation.postreviewSummary;
        self.postreviewRating.value = [thisObservation.postreviewRating floatValue];
    }else{
        self.postreviewSummary.text = thisObservation.prereviewSummary;
        self.postreviewRating.value = [thisObservation.prereviewRating floatValue];
    }
    [self.postReviewView setHidden:NO];
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options: UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         self.postReviewView.frame = CGRectMake(256, 20, 512, 313);
//                     }
//                     completion:^(BOOL finished){
//                     }];
//    [self.postreviewSummary becomeFirstResponder];
}

//slides the postreview summary text box back up out of view and saves the changes
- (IBAction)postReviewDone:(id)sender {
    [self.view endEditing:YES];
    thisObservation.postreviewRating = [NSNumber numberWithFloat:self.postreviewRating.value];
    thisObservation.postreviewSummary = self.postreviewSummary.text;
    [self save];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.postReviewView setHidden:YES];
                     }
                     completion:^(BOOL finished){
                     }];
}

//all they do is call [self refresh data];
- (IBAction)observerGapSwitch:(id)sender {
    [self refreshData];
}
- (IBAction)flowViewSwitcher:(id)sender {
    [self refreshData];
}
- (IBAction)dimSwitcher:(id)sender {
    [self refreshData];
}

//Refreshes the XYPieChart and Core Plot Graphs with new data.
- (void) refreshData {
    if ([self.flowViewSwitch isOn]) {
        switch ([self.dimSwitcherControl selectedSegmentIndex]) {
            {case 0:
                [self caseZero];
                [self flowChart];
                break;}
            {case 1:
                [self caseOne];
                [self flowChart];
                break;}
            {case 2:
                [self caseTwo];
                [self flowChart];
                break;}
                
            default:
                break;
        }
    }else{
        switch ([self.dimSwitcherControl selectedSegmentIndex]) {
            {case 0:
                [self caseZero];
                break;}
            {case 1:
                [self caseOne];
                break;}
            {case 2:
                [self caseTwo];
                break;}
                
            default:
                break;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    //grab all the images for each graph for the PDF Then refresh data to original dimswitcher and flowview switch selections
    [self.dimSwitcherControl setSelectedSegmentIndex:1];
    [self caseOne];
    [self flowChart];
    [self.dimSwitcherControl setSelectedSegmentIndex:2];
    [self caseTwo];
    [self flowChart];
    [self.dimSwitcherControl setSelectedSegmentIndex:0];
    [self caseZero];
    [self flowChart];
    [self refreshData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    thisObservation = self.passingObservations[self.passingObservation];
    events = [[NSMutableDictionary alloc] init];
    eventGaps = [[NSMutableDictionary alloc] init];
    imgDictPDF = [[NSMutableDictionary alloc]init];
    count = 1;
    upsizer = 1.5;
    for (int x = 0; x <= thisObservation.events.count - 1; x++){
        if (x % 2 == 0) {
            start = thisObservation.events[x];
        }else{
            end = thisObservation.events[x];
        }if (start && end) {
            NSString *key = [NSString stringWithFormat:@"%02lu",(unsigned long)count];
            NSTimeInterval lessonSpan = [end timeIntervalSinceDate:start];
            double lessonSpanMinutes = lessonSpan / 60;
            int rounded = lroundf(lessonSpanMinutes);
            [events setObject:[NSNumber numberWithDouble:rounded] forKey:key];
            start = nil;
            end = nil;
            count++;
        }
    }
    
    self.postReviewView.layer.borderColor = [UIColor grayColor].CGColor;
    self.postReviewView.layer.borderWidth = 1.0f;
    
    for (int i = 1; i <= thisObservation.events.count - 1; i++) {
        NSString *key = [NSString stringWithFormat:@"%02d",i/2];
        if (i % 2 == 0) {
            start = thisObservation.events[i];
            NSTimeInterval gap = [start timeIntervalSinceDate:end];
            double gapMinutes = gap / 60;
            [eventGaps setObject:[NSNumber numberWithDouble:gapMinutes] forKey:key];
            start = nil;
            end = nil;
        }else{
            end = thisObservation.events[i];
        }
    }
    
    NSDate *lastEvent = [thisObservation.events lastObject];
    NSDate *firstEvent = [thisObservation.events firstObject];
    totalClassLength = [lastEvent timeIntervalSinceDate:firstEvent];
    totalClassLength = totalClassLength / 60;
    
    NSLog(@"events: %@",events);
    NSLog(@"eventGaps: %@",eventGaps);
    
    //Prevents the segmented control segments for Dimension B and C from being enabled if there are no selections in the observation for B/C
    for (NSString *x in thisObservation.activities) {
        if ([x hasPrefix:@"DimC"]){
            [self.dimSwitcherControl setEnabled:YES forSegmentAtIndex:2];
        }else if ([x hasPrefix:@"DimB"]){
            [self.dimSwitcherControl setEnabled:YES forSegmentAtIndex:1];
        }
    }
    
# pragma mark - Start of PieChart Instantiation Code
    [self.dimAActivityChart setDataSource:self];
    [self.dimAActivityChart setDelegate:self];
    [self.dimAActivityChart setAnimationSpeed:.75];
    [self.dimAActivityChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
    [self.dimAActivityChart setLabelRadius:100];
    [self.dimAActivityChart setShowPercentage:YES];
    [self.dimAActivityChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.dimAActivityChart setPieCenter:CGPointMake(132, 130)];
    [self.dimAActivityChart setUserInteractionEnabled:YES];
    [self.dimAActivityChart setLabelShadowColor:[UIColor grayColor]];
    
    [self.dimATimeChart setDataSource:self];
    [self.dimATimeChart setDelegate:self];
    [self.dimATimeChart setAnimationSpeed:.75];
    [self.dimATimeChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
    [self.dimATimeChart setLabelRadius:100];
    [self.dimATimeChart setShowPercentage:YES];
    [self.dimATimeChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.dimATimeChart setPieCenter:CGPointMake(132, 130)];
    [self.dimATimeChart setUserInteractionEnabled:YES];
    [self.dimATimeChart setLabelShadowColor:[UIColor grayColor]];
    
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:130/255.0 green:88/255.0 blue:35/255.0 alpha:1], //lion brown
                       [UIColor colorWithRed:24/255.0 green:91/255.0 blue:59/255.0 alpha:1],  //darkish green
                       [UIColor colorWithRed:122/255.0 green:126/255.0 blue:206/255.0 alpha:1],//periwinkle-ish
                       [UIColor colorWithRed:66/255.0 green:39/255.0 blue:5/255.0 alpha:1], //dark brown
                       [UIColor colorWithRed:150/255.0 green:206/255.0 blue:179/255.0 alpha:1], //pastel green
                       [UIColor colorWithRed:163/255.0 green:90/255.0 blue:65/255.0 alpha:1], //pastel rose
                       [UIColor colorWithRed:250/255.0 green:197/255.0 blue:33/255.0 alpha:1], //lion yellow
                       [UIColor colorWithRed:35/255.0 green:36/255.0 blue:58/255.0 alpha:1], //dark blue
                       nil];
    
    self.sliceColorsDim =[NSArray arrayWithObjects:
                          [UIColor colorWithRed:130/255.0 green:88/255.0 blue:35/255.0 alpha:1], //lion brown
                          [UIColor colorWithRed:24/255.0 green:91/255.0 blue:59/255.0 alpha:1],  //darkish green
                          [UIColor colorWithRed:122/255.0 green:126/255.0 blue:206/255.0 alpha:1],//periwinkle-ish
                          [UIColor colorWithRed:66/255.0 green:39/255.0 blue:5/255.0 alpha:1], //dark brown
                          [UIColor colorWithRed:150/255.0 green:206/255.0 blue:179/255.0 alpha:1], //pastel green
                          [UIColor colorWithRed:163/255.0 green:90/255.0 blue:65/255.0 alpha:1], //pastel rose
                          [UIColor colorWithRed:250/255.0 green:197/255.0 blue:33/255.0 alpha:1], //lion yellow
                          [UIColor colorWithRed:35/255.0 green:36/255.0 blue:58/255.0 alpha:1], //dark blue
                          nil];
}

// Saves observation data to iPad
- (void) save {
    self.passingObservations[self.passingObservation] = thisObservation;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
    [NSKeyedArchiver archiveRootObject:self.passingObservations toFile:fileName];
}

//Create dataset for display from Dim A (caseZero), B (caseOne), or C (caseTwo)
- (void) caseZero {
    self.selectedSliceLabel.text = nil;
    self.selectedSliceLabelActivity.text = nil;
    //get length for each activity.
    dimValues = [[NSMutableDictionary alloc] init];
    dimTitles = [[NSMutableDictionary alloc] init];
    allDimFields = [[NSArray alloc] initWithObjects:@"1. Concepts of Print",@"2. Phonological Awareness",@"3. Alphabetic Knowledge", @"4. Word Study/Phonics/Decoding", @"5. Spelling", @"6. Vocabulary", @"7. Fluency", @"8. Text Reading", @"9. Comprehension", @"10. Writing", @"11. Non Language Arts Activities", @"12. Transition", nil];
    customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6], [NSDecimalNumber numberWithInt:7], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:9], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:11],[NSDecimalNumber numberWithInt:12], nil];
    //get title of each Dim A selected during observation and put it in activityDimAValueArray Chronologically.
    for (NSString *x in events) {
        NSString *innerDictKey = [NSString stringWithFormat:@"DimA %@",x];
        if (thisObservation.activities[innerDictKey]) {
            [dimTitles setObject:thisObservation.activities[innerDictKey] forKey:x];
            [dimValues setObject:events[x] forKey:x];
        }
    }
    
    dimCombinedEvents = [[NSMutableDictionary alloc] init];
    for (NSString *x in [dimTitles allKeys]) {
        NSArray *array = [NSArray arrayWithArray:dimTitles[x]];
        for (NSString *str in array) {
            if (dimCombinedEvents[str]) {
                int add = [dimCombinedEvents[str] intValue];
                NSNumber *new = [NSNumber numberWithInt:(add + [dimValues[x] intValue])];
                [dimCombinedEvents setObject:new forKey:str];
            }else{
                [dimCombinedEvents setObject:dimValues[x] forKey:str];
            }
        }
    }
    if ([self.observerGapSwitch isOn]) {
        NSArray *eventGapsArray = [NSArray arrayWithArray:[eventGaps allValues]];
        NSNumber *sum = [eventGapsArray valueForKeyPath:@"@sum.self"];
        [dimCombinedEvents setObject:sum forKey:@"Observer Gap"];
    }

    dimCounted = [[NSMutableDictionary alloc] init];
    dimOrderedTitles = [[NSMutableArray alloc] init];
    count = 1;
    int a = 0;
    int b = 0;
    int c = 0;
    int d = 0;
    int e = 0;
    int f = 0;
    int g = 0;
    int h = 0;
    int i = 0;
    int j = 0;
    int k = 0;
    int l = 0;
    for (NSMutableArray *dimAArray in [dimTitles allValues]) {
        for (NSString *dimA in dimAArray) {
            if ([dimA isEqualToString:@"1. Concepts of Print"]) {
                a++;
            }
            if ([dimA isEqualToString:@"2. Phonological Awareness"]) {
                b++;
            }
            if ([dimA isEqualToString:@"3. Alphabetic Knowledge"]) {
                c++;
            }
            if ([dimA isEqualToString:@"4. Word Study/Phonics/Decoding"]) {
                d++;
            }
            if ([dimA isEqualToString:@"5. Spelling"]) {
                e++;
            }
            if ([dimA isEqualToString:@"6. Vocabulary"]) {
                f++;
            }
            if ([dimA isEqualToString:@"7. Fluency"]) {
                g++;
            }
            if ([dimA isEqualToString:@"8. Text Reading"]) {
                h++;
            }
            if ([dimA isEqualToString:@"9. Comprehension"]) {
                i++;
            }
            if ([dimA isEqualToString:@"10. Writing"]) {
                j++;
            }
            if ([dimA isEqualToString:@"11. Non Language Arts Activities"]) {
                k++;
            }
            if ([dimA isEqualToString:@"12. Transition"]) {
                l++;
            }
        }
    }
    
    if (a > 0) {
        NSString *title = [NSString stringWithFormat:@"1. Concepts of Print"];
        [dimCounted setObject:[NSNumber numberWithInt:a] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (b > 0) {
        NSString *title = [NSString stringWithFormat:@"2. Phonological Awareness"];
        [dimCounted setObject:[NSNumber numberWithInt:b] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (c > 0) {
        NSString *title = [NSString stringWithFormat:@"3. Alphabetic Knowledge"];
        [dimCounted setObject:[NSNumber numberWithInt:c] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (d > 0) {
        NSString *title = [NSString stringWithFormat:@"4. Word Study/Phonics/Decoding"];
        [dimCounted setObject:[NSNumber numberWithInt:d] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (e > 0) {
        NSString *title = [NSString stringWithFormat:@"5. Spelling"];
        [dimCounted setObject:[NSNumber numberWithInt:e] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (f > 0) {
        NSString *title = [NSString stringWithFormat:@"6. Vocabulary"];
        [dimCounted setObject:[NSNumber numberWithInt:f] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (g > 0) {
        NSString *title = [NSString stringWithFormat:@"7. Fluency"];
        [dimCounted setObject:[NSNumber numberWithInt:g] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (h > 0) {
        NSString *title = [NSString stringWithFormat:@"8. Text Reading"];
        [dimCounted setObject:[NSNumber numberWithInt:h] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (i > 0) {
        NSString *title = [NSString stringWithFormat:@"9. Comprehension"];
        [dimCounted setObject:[NSNumber numberWithInt:i] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (j > 0) {
        NSString *title = [NSString stringWithFormat:@"10. Writing"];
        [dimCounted setObject:[NSNumber numberWithInt:j] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (k > 0) {
        NSString *title = [NSString stringWithFormat:@"11. Non Language Arts Activities"];
        [dimCounted setObject:[NSNumber numberWithInt:k] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (l > 0) {
        NSString *title = [NSString stringWithFormat:@"12. Transition"];
        [dimCounted setObject:[NSNumber numberWithInt:l] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if ([self.observerGapSwitch isOn]) {
        NSString *title = [NSString stringWithFormat:@"Observer Gap"];
        [dimOrderedTitles addObject:title];
    }
    
    dimCountedArray = [[NSMutableArray alloc] init];
    for (NSString *x in allDimFields) {
        if (dimCounted[x]) {
            [dimCountedArray addObject:dimCounted[x]];
        }
    }
    
    [self flowViewData];
    [self averageEventTime];
//    [self minEventTime];
//    [self maxEventTime];
    [self scatterPlot];
    [self timePieCPT];
    [self activityPieCPT];

    [self.dimAActivityChart reloadData];
    [self.dimATimeChart reloadData];
//    [NSTimer scheduledTimerWithTimeInterval:.75 target:self selector:@selector(getImages) userInfo:nil repeats:NO];
}
- (void) caseOne {
    self.selectedSliceLabel.text = nil;
    self.selectedSliceLabelActivity.text = nil;
    //get length for each activity.
    dimValues = [[NSMutableDictionary alloc] init];
    dimTitles = [[NSMutableDictionary alloc] init];
    allDimFields = [[NSArray alloc] initWithObjects:@"Whole Class",@"Small Group",@"Pairing",@"Independent",@"Individualized",@"Other: (describe in notes)",nil];
    customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6], nil];
    //get title of each Dim A selected during observation and put it in activityDimAValueArray Chronologically.
    for (NSString *x in events) {
        NSString *innerDictKey = [NSString stringWithFormat:@"DimB %@",x];
        if (thisObservation.activities[innerDictKey]) {
            [dimTitles setObject:thisObservation.activities[innerDictKey] forKey:x];
            [dimValues setObject:events[x] forKey:x];
        }
    }
    NSLog(@"dimB titles: %@",dimTitles);
    NSLog(@"dimB Values: %@",dimValues);
    
    dimCombinedEvents = [[NSMutableDictionary alloc] init];
    for (NSString *x in dimTitles) {
        NSArray *array = [NSArray arrayWithArray:dimTitles[x]];
        for (NSString *str in array) {
//            NSString *key = [NSString stringWithFormat:@"%@",str];
            if (dimCombinedEvents[str]) {
                int add = [dimCombinedEvents[str] intValue];
                NSNumber *new = [NSNumber numberWithInt:(add + [dimValues[x] intValue])];
                [dimCombinedEvents setObject:new forKey:str];
            }else{
                [dimCombinedEvents setObject:dimValues[x] forKey:str];
            }
        }
    }
    if ([self.observerGapSwitch isOn]) {
        NSArray *eventGapsArray = [NSArray arrayWithArray:[eventGaps allValues]];
        NSNumber *sum = [eventGapsArray valueForKeyPath:@"@sum.self"];
        [dimCombinedEvents setObject:sum forKey:@"Observer Gap"];
    }

    dimCounted = [[NSMutableDictionary alloc] init];
    dimOrderedTitles = [[NSMutableArray alloc] init];
    count = 1;
    int aB = 0;
    int bB = 0;
    int cB = 0;
    int dB = 0;
    int eB = 0;
    int fB = 0;
    for (NSMutableArray *dimAArray in [dimTitles allValues]) {
        for (NSString *dimA in dimAArray) {
            
            if ([dimA isEqualToString:@"Whole Class"]) {
                aB++;
            }
            if ([dimA isEqualToString:@"Small Group"]) {
                bB++;
            }
            if ([dimA isEqualToString:@"Pairing"]) {
                cB++;
            }
            if ([dimA isEqualToString:@"Independent"]) {
                dB++;
            }
            if ([dimA isEqualToString:@"Individualized"]) {
                eB++;
            }
            if ([dimA isEqual:@"Other: (describe in notes)"]) {
                fB++;
            }
        }
    }
    
    if (aB > 0) {
        NSString *title = [NSString stringWithFormat:@"Whole Class"];
        [dimCounted setObject:[NSNumber numberWithInt:aB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (bB > 0) {
        NSString *title = [NSString stringWithFormat:@"Small Group"];
        [dimCounted setObject:[NSNumber numberWithInt:bB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (cB > 0) {
        NSString *title = [NSString stringWithFormat:@"Pairing"];
        [dimCounted setObject:[NSNumber numberWithInt:cB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (dB > 0) {
        NSString *title = [NSString stringWithFormat:@"Independent"];
        [dimCounted setObject:[NSNumber numberWithInt:dB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (eB > 0) {
        NSString *title = [NSString stringWithFormat:@"Individualized"];
        [dimCounted setObject:[NSNumber numberWithInt:eB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (fB > 0) {
        NSString *title = [NSString stringWithFormat:@"Other: (describe in notes)"];
        [dimCounted setObject:[NSNumber numberWithInt:fB] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if ([self.observerGapSwitch isOn]) {
        NSString *title = [NSString stringWithFormat:@"Observer Gap"];
        [dimOrderedTitles addObject:title];
    }
    
    dimCountedArray = [[NSMutableArray alloc] init];
    for (NSString *x in allDimFields) {
        if (dimCounted[x]) {
            [dimCountedArray addObject:dimCounted[x]];
        }
    }
    
    [self flowViewData];
    [self averageEventTime];
//    [self minEventTime];
//    [self maxEventTime];
    [self timePieCPT];
    [self activityPieCPT];
    [self scatterPlot];
    [self.dimAActivityChart reloadData];
    [self.dimATimeChart reloadData];
//    [NSTimer scheduledTimerWithTimeInterval:.75 target:self selector:@selector(getImages) userInfo:nil repeats:NO];
}
- (void) caseTwo {
    self.selectedSliceLabel.text = nil;
    self.selectedSliceLabelActivity.text = nil;
    //get length for each activity.
    dimValues = [[NSMutableDictionary alloc] init];
    dimTitles = [[NSMutableDictionary alloc] init];
    allDimFields = [[NSArray alloc] initWithObjects:@"Audio-Tapes, CDs, etc.",@"Big Book (or similar)",@"Computers/iPads",@"Games, Puzzles, or Songs",@"Manipulatives",@"Oral Language",@"Pencil and Paper",@"Poster/Bulletin Board",@"Text-Basal",@"Text Decodable",@"Text-Pattern",@"Text-Student or Teacher Made",@"Text-Trade Book",@"Text-Unknown",@"Visuals-with Print",@"Visuals-without Print",@"Whiteboard, SmartBoard, etc.",@"Word Wall",@"Words out of Context",@"Workbooks/Worksheets",@"Other: (describe in notes)", nil];
    customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6],[NSDecimalNumber numberWithInt:7], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:9], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:11], [NSDecimalNumber numberWithInt:12],[NSDecimalNumber numberWithInt:13], [NSDecimalNumber numberWithInt:14], [NSDecimalNumber numberWithInt:15], [NSDecimalNumber numberWithInt:16], [NSDecimalNumber numberWithInt:17], [NSDecimalNumber numberWithInt:18],[NSDecimalNumber numberWithInt:19], [NSDecimalNumber numberWithInt:20], [NSDecimalNumber numberWithInt:21], nil];
    //get title of each Dim A selected during observation and put it in activityDimAValueArray Chronologically.
    for (NSString *x in events) {
        NSString *innerDictKey = [NSString stringWithFormat:@"DimC %@",x];
        if (thisObservation.activities[innerDictKey]) {
            [dimTitles setObject:thisObservation.activities[innerDictKey] forKey:x];
            [dimValues setObject:events[x] forKey:x];
        }
    }
    
    dimCombinedEvents = [[NSMutableDictionary alloc] init];
    for (NSString *x in [events allKeys]) {
        NSArray *array = [NSArray arrayWithArray:dimTitles[x]];
        for (NSString *str in array) {
            if (dimCombinedEvents[str]) {
                int add = [dimCombinedEvents[str] intValue];
                NSNumber *new = [NSNumber numberWithInt:(add + [dimValues[x] intValue])];
                [dimCombinedEvents setObject:new forKey:str];
            }else{
                [dimCombinedEvents setObject:dimValues[x] forKey:str];
            }
        }
    }
    if ([self.observerGapSwitch isOn]) {
        NSArray *eventGapsArray = [NSArray arrayWithArray:[eventGaps allValues]];
        NSNumber *sum = [eventGapsArray valueForKeyPath:@"@sum.self"];
        [dimCombinedEvents setObject:sum forKey:@"Observer Gap"];
    }
    
    if (dimCombinedEvents.count > 9) {
        upsizer = 1.0f;
    }
    
    dimCounted = [[NSMutableDictionary alloc] init];
    dimOrderedTitles = [[NSMutableArray alloc] init];
    count = 1;
    int a = 0;
    int b = 0;
    int c = 0;
    int d = 0;
    int e = 0;
    int f = 0;
    int g = 0;
    int h = 0;
    int i = 0;
    int j = 0;
    int k = 0;
    int l = 0;
    int m = 0;
    int n = 0;
    int o = 0;
    int p = 0;
    int q = 0;
    int r = 0;
    int s = 0;
    int t = 0;
    int u = 0;
    
    for (NSMutableArray *dimAArray in [dimTitles allValues]) {
        for (NSString *dimC in dimAArray) {
            if ([dimC isEqualToString:@"Audio-Tapes, CDs, etc."]) {
                a++;
            }
            if ([dimC isEqualToString:@"Big Book (or similar)"]) {
                b++;
            }
            if ([dimC isEqualToString:@"Computers/iPads"]) {
                c++;
            }
            if ([dimC isEqualToString:@"Games, Puzzles, or Songs"]) {
                d++;
            }
            if ([dimC isEqualToString:@"Manipulatives"]) {
                e++;
            }
            if ([dimC isEqual:@"Oral Language"]) {
                f++;
            }
            if ([dimC isEqual:@"Pencil and Paper"]) {
                g++;
            }
            if ([dimC isEqual:@"Poster/Bulletin Board"]) {
                h++;
            }
            if ([dimC isEqual:@"Text-Basal"]) {
                i++;
            }
            if ([dimC isEqual:@"Text Decodable"]) {
                j++;
            }
            if ([dimC isEqual:@"Text-Pattern"]) {
                k++;
            }
            if ([dimC isEqual:@"Text-Student or Teacher Made"]) {
                l++;
            }
            if ([dimC isEqual:@"Text-Trade Book"]) {
                m++;
            }
            if ([dimC isEqual:@"Text-Unknown"]) {
                n++;
            }
            if ([dimC isEqual:@"Visuals-with Print"]) {
                o++;
            }
            if ([dimC isEqual:@"Visuals-without Print"]) {
                p++;
            }
            if ([dimC isEqual:@"Whiteboard, SmartBoard, etc."]) {
                q++;
            }
            if ([dimC isEqual:@"Word Wall"]) {
                r++;
            }
            if ([dimC isEqual:@"Words out of Context"]) {
                s++;
            }
            if ([dimC isEqual:@"Workbooks/Worksheets"]) {
                t++;
            }
            if ([dimC isEqual:@"Other: (describe in notes)"]) {
                u++;
            }
        }
    }
    
    if (a > 0) {
        NSString *title = [NSString stringWithFormat:@"Audio-Tapes, CDs, etc."];
        [dimCounted setObject:[NSNumber numberWithInt:a] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (b > 0) {
        NSString *title = [NSString stringWithFormat:@"Big Book (or similar)"];
        [dimCounted setObject:[NSNumber numberWithInt:b] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (c > 0) {
        NSString *title = [NSString stringWithFormat:@"Computers/iPads"];
        [dimCounted setObject:[NSNumber numberWithInt:c] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (d > 0) {
        NSString *title = [NSString stringWithFormat:@"Games, Puzzles, or Songs"];
        [dimCounted setObject:[NSNumber numberWithInt:d] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (e > 0) {
        NSString *title = [NSString stringWithFormat:@"Manipulatives"];
        [dimCounted setObject:[NSNumber numberWithInt:e] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (f > 0) {
        NSString *title = [NSString stringWithFormat:@"Oral Language"];
        [dimCounted setObject:[NSNumber numberWithInt:f] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (g > 0) {
        NSString *title = [NSString stringWithFormat:@"Pencil and Paper"];
        [dimCounted setObject:[NSNumber numberWithInt:g] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (h > 0) {
        NSString *title = [NSString stringWithFormat:@"Poster/Bulletin Board"];
        [dimCounted setObject:[NSNumber numberWithInt:h] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (i > 0) {
        NSString *title = [NSString stringWithFormat:@"Text-Basal"];
        [dimCounted setObject:[NSNumber numberWithInt:i] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (j > 0) {
        NSString *title = [NSString stringWithFormat:@"Text Decodable"];
        [dimCounted setObject:[NSNumber numberWithInt:j] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (k > 0) {
        NSString *title = [NSString stringWithFormat:@"Text-Pattern"];
        [dimCounted setObject:[NSNumber numberWithInt:k] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (l > 0) {
        NSString *title = [NSString stringWithFormat:@"Text-Student or Teacher Made"];
        [dimCounted setObject:[NSNumber numberWithInt:l] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (m > 0) {
        NSString *title = [NSString stringWithFormat:@"Text-Trade Book"];
        [dimCounted setObject:[NSNumber numberWithInt:m] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (n > 0) {
        NSString *title = [NSString stringWithFormat:@"Text-Unknown"];
        [dimCounted setObject:[NSNumber numberWithInt:n] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (o > 0) {
        NSString *title = [NSString stringWithFormat:@"Visuals-with Print"];
        [dimCounted setObject:[NSNumber numberWithInt:o] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (p > 0) {
        NSString *title = [NSString stringWithFormat:@"Visuals-without Print"];
        [dimCounted setObject:[NSNumber numberWithInt:p] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (q > 0) {
        NSString *title = [NSString stringWithFormat:@"Whiteboard, SmartBoard, etc."];
        [dimCounted setObject:[NSNumber numberWithInt:q] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (r > 0) {
        NSString *title = [NSString stringWithFormat:@"Word Wall"];
        [dimCounted setObject:[NSNumber numberWithInt:r] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (s > 0) {
        NSString *title = [NSString stringWithFormat:@"Words out of Context"];
        [dimCounted setObject:[NSNumber numberWithInt:s] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (t > 0) {
        NSString *title = [NSString stringWithFormat:@"Workbooks/Worksheets"];
        [dimCounted setObject:[NSNumber numberWithInt:t] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if (u > 0) {
        NSString *title = [NSString stringWithFormat:@"Other: (describe in notes)"];
        [dimCounted setObject:[NSNumber numberWithInt:u] forKey:title];
        [dimOrderedTitles addObject:title];
    }
    if ([self.observerGapSwitch isOn]) {
        NSString *title = [NSString stringWithFormat:@"Observer Gap"];
        [dimOrderedTitles addObject:title];
    }
    
    dimCountedArray = [[NSMutableArray alloc] init];
    for (NSString *x in allDimFields) {
        if (dimCounted[x]) {
            [dimCountedArray addObject:dimCounted[x]];
        }
    }
    
    [self flowViewData];
    [self averageEventTime];
//    [self minEventTime];
//    [self maxEventTime];
    [self timePieCPT];
    [self activityPieCPT];
    [self scatterPlot];
    [self.dimAActivityChart reloadData];
    [self.dimATimeChart reloadData];
//    [NSTimer scheduledTimerWithTimeInterval:.75 target:self selector:@selector(getImages) userInfo:nil repeats:NO];
}

//Calculates average durations for the ScatterView Core Plot Graph
- (void) averageEventTime {
    //dictionary containing average length of each activity. Includes EVERY field.
    scatterAverage = [[NSMutableArray alloc] init];
    NSMutableDictionary *scatterAverageTemp = [[NSMutableDictionary alloc] init];
    for (NSString *x in allDimFields) {
        if (dimCombinedEvents[x]) {
            NSNumber *eventAverage = [NSNumber numberWithInt:[dimCombinedEvents[x] intValue] / [dimCounted[x] intValue]];
            [scatterAverageTemp setObject:eventAverage forKey:x];
        }else{
            NSNumber *elseVal = [NSNumber numberWithInt:-1];
            [scatterAverageTemp setObject:elseVal forKey:x];
        }
    }
    NSNumber *average = [[dimValues allValues] valueForKeyPath:@"@avg.self"];
    for (NSString *key in allDimFields) {
        [scatterAverage addObject:scatterAverageTemp[key]];
    }
    [scatterAverage addObject:average];
//    NSLog(@"Scatter Avg: %@",scatterAverage);
}
/* no more error bars
- (void) minEventTime {
    //dictionary containing average length of each activity. Includes EVERY field.
    scatterMin = [[NSMutableArray alloc] init];
    NSMutableDictionary *scatterMinTemp = [[NSMutableDictionary alloc]init];
    for (NSArray *x in dimTitles) {
        NSArray *arr = [NSArray arrayWithArray:dimTitles[x]];
        for (NSString *key in arr) {
            if (scatterMinTemp[key]) {
                if ([dimValues[x] isLessThan:scatterMinTemp[key]]) {
                    [scatterMinTemp setObject:dimValues[x] forKey:key];
                }
            }else{
                [scatterMinTemp setObject:dimValues[x] forKey:key];
            }
        }
    }
    for (NSString *x in allDimFields) {
        if (scatterMinTemp[x]) {
            [scatterMin addObject:scatterMinTemp[x]];
        }else {
            NSNumber *num = [NSNumber numberWithInt:-1];
            [scatterMin addObject: num];
        }
    }
//    NSLog(@"Scatter Min: %@",scatterMin);
}
- (void) maxEventTime {
    //dictionary containing average length of each activity. Includes EVERY field.
    scatterMax = [[NSMutableArray alloc] init];
    NSMutableDictionary *scatterMaxTemp = [[NSMutableDictionary alloc]init];
    for (NSArray *x in dimTitles) {
        NSArray *arr = [NSArray arrayWithArray:dimTitles[x]];
        for (NSString *key in arr) {
            if (scatterMaxTemp[key]) {
                if ([dimValues[x] isGreaterThan:scatterMaxTemp[key]]) {
                    [scatterMaxTemp setObject:dimValues[x] forKey:key];
                }
            }else{
                [scatterMaxTemp setObject:dimValues[x] forKey:key];
            }
        }
    }
    for (NSString *x in allDimFields) {
        if (scatterMaxTemp[x]) {
            [scatterMax addObject:scatterMaxTemp[x]];
        }else {
            NSNumber *num = [NSNumber numberWithInt:-1];
            [scatterMax addObject:num];
        }
    }
//    NSLog(@"Scatter Max: %@",scatterMax);
}
*/

//Creates data for the FlowView Core Plot Graph
- (void) flowViewData {
    totalLength = 0;
    flowEventTips = [[NSMutableArray alloc] init];
    flowEventsBases = [[NSMutableArray alloc] init];
    for (int x = 1; x < events.count + 1; x++) {
        NSString *key = [NSString stringWithFormat:@"%02d",x];
        if (!dimValues[key]) {
            totalLength = totalLength + [events[key] intValue];
        }
        NSNumber *len = [NSNumber numberWithInt:totalLength];
        NSArray *dimTitlesArr = [NSArray arrayWithArray:dimTitles[key]];
        for (int x = 1; x <= dimTitlesArr.count; x++) {
            [flowEventsBases addObject:len];
        }
        totalLength = totalLength + [dimValues[key] intValue];
        len = [NSNumber numberWithInt:totalLength];
        for (int x = 1; x <= dimTitlesArr.count; x++) {
            [flowEventTips addObject:len];
        }
        if (eventGaps[key]) {
            totalLength = totalLength + [eventGaps[key] intValue];
        }
    }
    flowTitles = [[NSMutableArray alloc] init];
    for (int x = 1; x <= events.count; x++) {
        NSString *key = [NSString stringWithFormat:@"%02d",x];
        NSArray *arr = [NSArray arrayWithArray:dimTitles[key]];
        for (NSString *k in arr) {
            [flowTitles addObject:k];
        }
    }
}

//Core Plot Graph Setup
- (void) scatterPlot {
    // Create a CPTGraph object and add to hostView
    graph = [[CPTXYGraph alloc] initWithFrame:self.corePlotHostingView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.corePlotHostingView.hostedGraph = graph;
    graph.titleDisplacement = CGPointMake(0, 20);
    
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        graph.title = @"Average Duration of Instructional Events";
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        graph.title = @"Average Duration of Grouping Formats";
    }else {
        graph.title = @"Average Duration of Materials Used";
    }
    
//    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.paddingBottom = 140.0f;
    graph.paddingLeft  = 60.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingRight  = 0.0f;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    CGFloat xMin = 0.0f;
    CGFloat xMax = allDimFields.count + .5;
    CGFloat yMin = 0.0f;
    CGFloat yMax = [[scatterAverage valueForKeyPath:@"@max.intValue"] floatValue] + 5;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
//    rPlot = [[CPTRangePlot alloc] initWithFrame:CGRectZero];
    sPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
//    rPlot.dataSource = self;
    sPlot.dataSource = self;
    sPlot.dataLineStyle = nil;
    CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    aaplSymbol.size = CGSizeMake(8, 8);
    aaplSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:130/255.0 green:88/255.0 blue:35/255.0 alpha:1]];
    sPlot.plotSymbol = aaplSymbol;

    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromDouble(1);
    x.orthogonalCoordinateDecimal = CPTDecimalFromInteger(2);
    x.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0f];
    x.minorTicksPerInterval       = 0;
    
    // Define some custom labels for the data elements
    x.labelRotation = M_PI/4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSSet *tickSet = [NSSet setWithArray:customTickLocations];
    x.majorTickLocations = tickSet;
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[allDimFields count]];
    for (NSNumber *tickLocation in customTickLocations) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [allDimFields objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset = x.labelOffset + x.majorTickLength;
        newLabel.rotation = M_PI/4;
        [customLabels addObject:newLabel];
    }
    x.axisLabels =  [NSSet setWithArray:customLabels];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.title = @"Minutes";
    y.titleOffset = 40.0f;
    y.majorIntervalLength         = CPTDecimalFromDouble(5);
    y.minorTicksPerInterval       = 1;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor colorWithGenericGray:0.90f];
    y.majorGridLineStyle = lineStyle;
    
    [graph addPlot:sPlot toPlotSpace:graph.defaultPlotSpace];
    
    UIImage *newImage = [graph imageOfLayer];
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        [imgDictPDF setObject:newImage forKey:@"scatterViewDimA"];
        }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        [imgDictPDF setObject:newImage forKey:@"scatterViewDimB"];
        }else {
        [imgDictPDF setObject:newImage forKey:@"scatterViewDimC"];
        }
}
- (void) timePieCPT {
    // Create a CPTGraph object and add to hostView
    CPTXYGraph *graphTimePie = [[CPTXYGraph alloc] initWithFrame:self.timePieCPTHostingView.bounds];
    graphTimePie.plotAreaFrame.masksToBorder = NO;
    self.timePieCPTHostingView.hostedGraph = graphTimePie;
    graphTimePie.axisSet = nil;
    graphTimePie.paddingBottom = 0.0f;
    graphTimePie.paddingLeft = 0.0f;
    graphTimePie.paddingRight = 0.0f;
    graphTimePie.paddingTop = 30.0f;
    
    CPTMutableTextStyle *titleText = [CPTMutableTextStyle textStyle];
    titleText.fontSize = 17.5f;
    graphTimePie.titleTextStyle = titleText;
    graphTimePie.titleDisplacement = CGPointMake(0, 32);
    
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        graphTimePie.title = @"Instructional Events - % Time";
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        graphTimePie.title = @"Grouping - % Time";
    }else {
        graphTimePie.title = @"Materials - % Time";;
    }

    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    timePieCPT = [[CPTPieChart alloc] initWithFrame:CGRectZero];
    timePieCPT.delegate = self;
    timePieCPT.dataSource = self;
    timePieCPT.pieRadius = (self.timePieCPTHostingView.bounds.size.width * 0.89) /2;
    timePieCPT.identifier = @"timePie";
//    timePieCPT.startAngle = -90.0f;
    timePieCPT.borderLineStyle = [CPTLineStyle lineStyle];
    timePieCPT.sliceDirection = CPTPieDirectionClockwise;
    timePieCPT.labelOffset = -35.f;
    
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    timePieCPT.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    [graphTimePie addPlot:timePieCPT];
    
    UIImage *newImage = [graphTimePie imageOfLayer];
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        [imgDictPDF setObject:newImage forKey:@"timeDimA"];
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        [imgDictPDF setObject:newImage forKey:@"timeDimB"];
    }else {
        [imgDictPDF setObject:newImage forKey:@"timeDimC"];
    }

}
- (void) activityPieCPT {
    // Create a CPTGraph object and add to hostView
    CPTXYGraph *graphActivityPie = [[CPTXYGraph alloc] initWithFrame:self.activityPieCPTHostingView.bounds];
    graphActivityPie.plotAreaFrame.masksToBorder = NO;
    self.activityPieCPTHostingView.hostedGraph = graphActivityPie;
    graphActivityPie.axisSet = nil;
    graphActivityPie.paddingBottom = 0.0f;
    graphActivityPie.paddingLeft = 0.0f;
    graphActivityPie.paddingRight = 0.0f;
    graphActivityPie.paddingTop = 30.0f;
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        graphActivityPie.title = @"Instructional Events - % Activities";
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        graphActivityPie.title = @"Grouping - % Activities";
    }else {
        graphActivityPie.title = @"Materials - % Activities";;
    }
    
    CPTMutableTextStyle *titleText = [CPTMutableTextStyle textStyle];
    titleText.fontSize = 17.5f;
    graphActivityPie.titleTextStyle = titleText;
//    graphActivityPie.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graphActivityPie.titleDisplacement = CGPointMake(0, 32);
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    activityPieCPT = [[CPTPieChart alloc] initWithFrame:CGRectZero];
    activityPieCPT.delegate = self;
    activityPieCPT.dataSource = self;
    activityPieCPT.pieRadius = (self.timePieCPTHostingView.bounds.size.width * 0.89) /2;
    activityPieCPT.identifier = @"timePie";
    //    timePieCPT.startAngle = -90.0f;
    activityPieCPT.borderLineStyle = [CPTLineStyle lineStyle];
    activityPieCPT.sliceDirection = CPTPieDirectionClockwise;
    activityPieCPT.labelOffset = -35.f;
    
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    activityPieCPT.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    [graphActivityPie addPlot:activityPieCPT];
    
    [self legend];
//    if (imgDictPDF.count < 15) {
//        [self getImages];
//    }
    UIImage *newImage = [graphActivityPie imageOfLayer];
    UIImage *legendImage = [graphActivityPie.legend imageOfLayer];
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        [imgDictPDF setObject:newImage forKey:@"activityDimA"];
        [imgDictPDF setObject:legendImage forKey:@"legendDimA"];
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        [imgDictPDF setObject:newImage forKey:@"activityDimB"];
        [imgDictPDF setObject:legendImage forKey:@"legendDimB"];
    }else {
        [imgDictPDF setObject:newImage forKey:@"activityDimC"];
        [imgDictPDF setObject:legendImage forKey:@"legendDimC"];
    }
}
- (void) legend {
    CPTGraph *agraph = self.activityPieCPTHostingView.hostedGraph;
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:agraph];
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
//    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.borderLineStyle = nil;
    CPTMutableTextStyle *smallerText = [CPTMutableTextStyle textStyle];
    smallerText.fontSize = 9.0f;
    theLegend.textStyle = smallerText;
    theLegend.cornerRadius = 5.0;
    
    agraph.legend = theLegend;
    agraph.legendAnchor = CPTRectAnchorTopLeft;
    agraph.legendDisplacement = CGPointMake(270.0, -30);
}
- (void) flowChart {
    // Create a CPTGraph object and add to hostView
    graph = [[CPTXYGraph alloc] initWithFrame:self.corePlotHostingView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.corePlotHostingView.hostedGraph = graph;
    graph.titleDisplacement = CGPointMake(0, 20);
    
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        graph.title = @"Sequence and Duration of Instructional Events";
    }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        graph.title = @"Sequence and Duration of Grouping Formats";
    }else {
        graph.title = @"Sequence and Duration of Materials Used";
    }
    
    //    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.paddingBottom = 60.0f;
    graph.paddingLeft  = 200.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingRight  = 0.0f;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    CGFloat xMin = 0.0f;
    CGFloat xMax = totalClassLength;
    CGFloat yMin = 0.0f;
    CGFloat yMax = allDimFields.count + 2;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    flowPlot = [[CPTBarPlot alloc] initWithFrame:CGRectZero];
    flowPlot.delegate = self;
    flowPlot.barsAreHorizontal = YES;
    flowPlot.barBasesVary = YES;
    flowPlot.dataSource = self;
    flowPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:130/255.0 green:88/255.0 blue:35/255.0 alpha:1.0]];
    CPTMutableLineStyle *linePlotStyle = [CPTMutableLineStyle lineStyle];
    linePlotStyle.lineColor = [CPTColor clearColor];
    flowPlot.lineStyle = linePlotStyle;
    flowPlot.barCornerRadius = 2.0f;
    flowPlot.barBaseCornerRadius = 2.0f;

    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *y          = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromDouble(1);
    y.orthogonalCoordinateDecimal = CPTDecimalFromInteger(2);
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0f];
    y.minorTicksPerInterval       = 0;
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor colorWithGenericGray:0.90f];
    y.majorGridLineStyle = lineStyle;
    y.labelOffset = 10.0f;
    
    // Define some custom labels for the data elements
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSSet *tickSet = [NSSet setWithArray:customTickLocations];
    y.majorTickLocations = tickSet;
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[allDimFields count]];
    NSMutableArray *allDimFieldsReversed = [[NSMutableArray alloc] init];
    for (NSString *str in [allDimFields reverseObjectEnumerator]) {
        [allDimFieldsReversed addObject:str];
    }
    for (NSNumber *tickLocation in customTickLocations) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [allDimFieldsReversed objectAtIndex:labelLocation++] textStyle:y.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset = y.labelOffset + y.majorTickLength;
        [customLabels addObject:newLabel];
    }
    y.axisLabels =  [NSSet setWithArray:customLabels];
    
    CPTXYAxis *x = axisSet.xAxis;
    x.title = @"Minutes";
    x.majorIntervalLength         = CPTDecimalFromDouble(15);
    x.minorTicksPerInterval       = 1;

    
    [graph addPlot:flowPlot toPlotSpace:graph.defaultPlotSpace];
    
    UIImage *newImage = [graph imageOfLayer];
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        [imgDictPDF setObject:newImage forKey:@"flowViewDimA"];
        }else if(self.dimSwitcherControl.selectedSegmentIndex == 1) {
        [imgDictPDF setObject:newImage forKey:@"flowViewDimB"];
        }else {
        [imgDictPDF setObject:newImage forKey:@"flowViewDimC"];
        }
}
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx {
    if (self.dimSwitcherControl.selectedSegmentIndex == 0) {
        NSDecimal plotPoint[2];
        NSNumber *plotXvalue = [self numberForPlot:plot
                                             field:CPTScatterPlotFieldX
                                       recordIndex:idx];
        plotPoint[CPTCoordinateY] = plotXvalue.decimalValue;
        
        NSNumber *plotYvalue = [self numberForPlot:plot
                                             field:CPTScatterPlotFieldY
                                       recordIndex:idx];
        plotPoint[CPTCoordinateX] = plotYvalue.decimalValue;
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        
        // convert from data coordinates to plot area coordinates
        CGPoint dataPoint = [plotSpace plotAreaViewPointForPlotPoint:plotPoint numberOfCoordinates:2];
        
        // convert from plot area coordinates to graph (and hosting view) coordinates
        dataPoint = [graph convertPoint:dataPoint fromLayer:self.corePlotHostingView.hostedGraph.plotAreaFrame.plotArea];
        //Flip the y coordinate upside down.
        dataPoint.y = 397 - dataPoint.y;
        
        // convert from hosting view coordinates to self.view coordinates (if needed)
        dataPoint = [self.view convertPoint:dataPoint fromView:self.corePlotHostingView];
        
        self.infoViewController = [[UIViewController alloc] init];
        UITextView *activityNotesDisplay = [[UITextView alloc] initWithFrame:(CGRectMake(0, 0, 400, 300))];
        activityNotesDisplay.editable = NO;
        
        NSString *notesKey = [NSString stringWithFormat:@"%02u Activity Notes", idx + 1];
        activityNotesDisplay.text = thisObservation.activityNotes[notesKey];
        
        self.infoViewController.view = activityNotesDisplay;

        
        self.popover = nil;
        self.popover = [[UIPopoverController alloc]
                        
                        
                        initWithContentViewController:self.infoViewController];
        self.popover.popoverContentSize = CGSizeMake(300, 150);
        CGRect popoverAnchor = CGRectMake(dataPoint.x, dataPoint.y, (CGFloat)1.0f, (CGFloat)1.0f);

        
        [self.popover presentPopoverFromRect:popoverAnchor
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionDown
                                    animated:YES];
    }
}

/*
//get screenshots for PDF Creation
- (void) getImages {
    //check if retina iPad or shitty iPad
    if ([UIScreen mainScreen].scale == 2.0){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *lImg = [[UIImage alloc] init];
    
    if ([UIScreen mainScreen].scale == 2.0){
        lImg = [self cropImage:image rect:CGRectMake(1124, 160, 320, 340)];
    }else{
        lImg = [self cropImage:image rect:CGRectMake(562, 80, 160, 170)];
    }
    
    NSString *lKey = [[NSString alloc] init];
    
    switch ([self.dimSwitcherControl selectedSegmentIndex]) {
        case 0:{
            lKey = [NSString stringWithFormat:@"legendDimA"];
            break;}
        case 1:{
            lKey = [NSString stringWithFormat:@"legendDimB"];
            break;}
        case 2:{
            lKey = [NSString stringWithFormat:@"legendDimC"];
            break;}
        default:
            break;
        }
    [imgDictPDF setValue:lImg forKeyPath:lKey];
}
- (UIImage *)cropImage:(UIImage *)image rect:(CGRect)cropRect {
    CGImageRef refImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *img = [UIImage imageWithCGImage:refImage];
    CGImageRelease(refImage);
    return img;
}
 */

//draw PDF
- (void)drawPDF {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileNames = [documentsDirectory stringByAppendingPathComponent: self.passingObservation];
    NSString *fileName = [NSString stringWithFormat:@"%@.PDF", fileNames];

    pdfFileName = fileName;
    float sizer = 1.5f;
    
    // Create the PDF context.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1700, 2200), nil);
    
    UIImage *lionLogo = [UIImage imageNamed:@"Lion_Color_option.png"];
    CGRect logoFrame = CGRectMake(40, 20, 966, 400);
    [lionLogo drawInRect:logoFrame];
    
    UIImage *scatterViewDimA = imgDictPDF[@"scatterViewDimA"];
    CGRect scatterViewDimAFrame = CGRectMake(40, 1229, 1200, 461);
    [scatterViewDimA drawInRect:scatterViewDimAFrame];
    
    UIImage *timeDimA = imgDictPDF[@"timeDimA"];
    CGRect timeDimAFrame = CGRectMake(1300, 1159, 330, 378);
    [timeDimA drawInRect:timeDimAFrame];
    
    UIImage *activityDimA = imgDictPDF[@"activityDimA"];
    CGRect activityDimAFrame = CGRectMake(1300, 1559, 330, 378);
    [activityDimA drawInRect:activityDimAFrame];
    
    UIImage *legendDimA = imgDictPDF[@"legendDimA"];
    CGRect legendDimAFrame = CGRectMake(1300, 1979, legendDimA.size.width * sizer, legendDimA.size.height * sizer);
    [legendDimA drawInRect:legendDimAFrame];
    
    UIImage *flowViewDimA = imgDictPDF[@"flowViewDimA"];
    CGRect flowViewDimAFrame = CGRectMake(40, 1739, 1200, 461);
    [flowViewDimA drawInRect:flowViewDimAFrame];

    NSString *title = [NSString stringWithFormat:@"%@",self.passingObservation];
    
    NSString *postReviewRating = [[NSString alloc] init];
    UIImage *stars = [[UIImage alloc] init];
    switch (thisObservation.postreviewRating.integerValue) {
        case 0: {
            stars = [UIImage imageNamed:@"star0.png"];
            postReviewRating = @"0";
            break;
        }
        case 1: {
            stars = [UIImage imageNamed:@"starhalf.png"];
            postReviewRating = @"0.5";
            break;
        }
        case 2: {
            stars = [UIImage imageNamed:@"star1.png"];
            postReviewRating = @"1";
            break;
        }
        case 3: {
            stars = [UIImage imageNamed:@"star1half.png"];
            postReviewRating = @"1.5";
            break;
        }
        case 4: {
            stars = [UIImage imageNamed:@"star2.png"];
            postReviewRating = @"2";
            break;
        }
        case 5: {
            stars = [UIImage imageNamed:@"star2half.png"];
            postReviewRating = @"2.5";
            break;
        }
        case 6: {
            stars = [UIImage imageNamed:@"star3.png"];
            postReviewRating = @"3";
            break;
        }
        default:
            break;
    }
    
    
    [stars drawInRect:CGRectMake(540, 1015, 164, 51)];
    [self drawText:title                               inFrame:CGRectMake(250, 539, 2000, 50)];
    [self drawText:@"Observation Summary"              inFrame:CGRectMake(40, 659, 400, 80)];
    [self drawText:thisObservation.postreviewSummary   inFrame:CGRectMake(40, 1439, 1620, 800)];
    [self drawText:@"Observation Rating:"              inFrame:CGRectMake(40, 1099, 400, 80)];
    [self drawText:postReviewRating                    inFrame:CGRectMake(420, 1099, 400, 80)];
    [self drawText:@"Instructional Events"             inFrame:CGRectMake(40, 1239, 400, 80)];

    
    //Draw line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, 40, 549);
    CGContextAddLineToPoint(context, 1660, 549);
    
    CGContextMoveToPoint(context, 40, 1099);
    CGContextAddLineToPoint(context, 1660, 1099);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);

    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1700, 2200), nil);
    
    [self drawText:title            inFrame:CGRectMake(250, 80, 2000, 50)];
    [self drawText:@"Grouping"      inFrame:CGRectMake(40, 200, 300, 80)];
    [self drawText:@"Materials"     inFrame:CGRectMake(40, 1230, 300, 80)];
    
    UIImage *scatterViewDimB = imgDictPDF[@"scatterViewDimB"];
    CGRect scatterViewDimBFrame = CGRectMake(40, 200, 1200, 461);
    [scatterViewDimB drawInRect:scatterViewDimBFrame];
    
    UIImage *timeDimB = imgDictPDF[@"timeDimB"];
    CGRect timeDimBFrame = CGRectMake(1300, 105, 330, 378);
    [timeDimB drawInRect:timeDimBFrame];
    
    UIImage *activityDimB = imgDictPDF[@"activityDimB"];
    CGRect activityDimBFrame = CGRectMake(1300, 490, 330, 378);
    [activityDimB drawInRect:activityDimBFrame];
    
    UIImage *legendDimB = imgDictPDF[@"legendDimB"];
    CGRect legendDimBFrame = CGRectMake(1300, 870, legendDimB.size.width * sizer, legendDimB.size.height * sizer);
    [legendDimB drawInRect:legendDimBFrame];
    
    UIImage *flowViewDimB = imgDictPDF[@"flowViewDimB"];
    CGRect flowViewDimBFrame = CGRectMake(40, 650, 1200, 461);
    [flowViewDimB drawInRect:flowViewDimBFrame];
    
    UIImage *scatterViewDimC = imgDictPDF[@"scatterViewDimC"];
    CGRect scatterViewDimCFrame = CGRectMake(40, 1200, 1200, 461);
    [scatterViewDimC drawInRect:scatterViewDimCFrame];
    
    UIImage *timeDimC = imgDictPDF[@"timeDimC"];
    CGRect timeDimCFrame = CGRectMake(1300, 1140, 330, 378);
    [timeDimC drawInRect:timeDimCFrame];
    
    UIImage *activityDimC = imgDictPDF[@"activityDimC"];
    CGRect activityDimCFrame = CGRectMake(1300, 1520, 330, 378);
    [activityDimC drawInRect:activityDimCFrame];
    
    UIImage *legendDimC = imgDictPDF[@"legendDimC"];
    CGRect legendDimCFrame = CGRectMake(1300, 1900, legendDimC.size.width * upsizer, legendDimC.size.height * upsizer);
    [legendDimC drawInRect:legendDimCFrame];
    
    UIImage *flowViewDimC = imgDictPDF[@"flowViewDimC"];
    CGRect flowViewDimCFrame = CGRectMake(40, 1720, 1200, 461);
    [flowViewDimC drawInRect:flowViewDimCFrame];
    
    //Draw line
    CGContextMoveToPoint(context, 40, 90);
    CGContextAddLineToPoint(context, 1660, 90);
    
    CGContextMoveToPoint(context, 40, 1120);
    CGContextAddLineToPoint(context, 1660, 1120);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);
    
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();

    [self composerSheetPDF];
}
- (void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect {
    NSUInteger length=[textToDraw length];
    CFStringRef stringRef = (__bridge CFStringRef) textToDraw;
    CFMutableAttributedStringRef currentText = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (currentText,CFRangeMake(0, 0), stringRef);
    UIFont *sysBoldFont=[UIFont boldSystemFontOfSize:10.f];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)sysBoldFont.fontName, 36.0f, nil);
    if (length > 80) {
        font = CTFontCreateWithName((CFStringRef)@"Helvetica", 26.0f, nil);
    }else {
        sysBoldFont=[UIFont boldSystemFontOfSize:10.f];
        font = CTFontCreateWithName((__bridge CFStringRef)sysBoldFont.fontName, 36.0f, nil);
    }
    CFAttributedStringSetAttribute(currentText,CFRangeMake(0, length),kCTFontAttributeName,font);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // Modify this to take into consideration the origin.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(frameRef);
//    CFRelease(stringRef);  //this is causing an EXC_BAD_ACCESS error so I commented it out
    CFRelease(framesetter);
}

//Attach and Mail PDF
-(void)composerSheetPDF {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Observation Review Sheet"];
    
    // Attach pdf to the email
    
    NSMutableData *myData =  [NSMutableData dataWithContentsOfFile:pdfFileName];
    [mailComposer addAttachmentData:myData mimeType:@"application/PDF" fileName:@"Observation Review.pdf"];
    
    // Fill out the email body text
    NSString *emailBody = @"Please see the attached observation review data.";
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

//Attach and Mail CSV
-(void)composerSheetCSV {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Observation Review Data"];
    
    // Attach CSV to the email
    
    NSMutableData *myData =  [NSMutableData dataWithContentsOfFile:tempFileName];
    [mailComposer addAttachmentData:myData mimeType:@"text/csv" fileName:@"Observation Data.csv"];
    
    // Fill out the email body text
    NSString *emailBody = @"Please see the attached observation review data.";
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
- (void) MakeCSV {
    
    NSNumber *countEvents = [NSNumber numberWithInt:thisObservation.events.count / 2];
    
    tempFileName = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSMutableArray *outputArray = [[NSMutableArray alloc] initWithObjects: tempFileName, thisObservation.districtName, thisObservation.schoolName, thisObservation.teacherName, thisObservation.observationDate, thisObservation.prereviewRating, thisObservation.prereviewSummary, thisObservation.postreviewRating, thisObservation.postreviewSummary, countEvents, nil];
    
//    thisObservation.observerName, thisObservation.numStudents,
    
    //enter data for individual events
    for (int x = 1; x < countEvents.intValue; x++) {
        NSString *key = [NSString stringWithFormat:@"%02d",x];
        NSString *DimAKey = [NSString stringWithFormat:@"DimA %02d",x];
        NSString *DimBKey = [NSString stringWithFormat:@"DimB %02d",x];
        NSString *DimCKey = [NSString stringWithFormat:@"DimC %02d",x];
        NSString *activityNotesKey = [NSString stringWithFormat:@"%02d Activity Notes",x];
        NSString *startingGoalKey = [NSString stringWithFormat:@"%02d Starting Goal",x];
        NSString *startingGoalModeKey = [NSString stringWithFormat:@"%02d Starting Goal Mode",x];
        NSString *endingGoalKey = [NSString stringWithFormat:@"%02d Ending Goal",x];
        NSString *endingGoalModeKey = [NSString stringWithFormat:@"%02d Ending Goal Mode",x];
        [outputArray addObject:events[key]];
        [outputArray addObject:eventGaps[key]];
        [outputArray addObject:thisObservation.activityNotes[activityNotesKey]];
        [outputArray addObject:thisObservation.activityNotes[startingGoalKey]];
        [outputArray addObject:thisObservation.activityNotes[startingGoalModeKey]];
        [outputArray addObject:thisObservation.activityNotes[endingGoalKey]];
        [outputArray addObject:thisObservation.activityNotes[endingGoalModeKey]];
        NSArray *dimA = thisObservation.activities[DimAKey];
        [outputArray addObject:dimA[0]];
        NSArray *dimB = thisObservation.activities[DimBKey];
        if (dimB[0]) {
            [outputArray addObject:dimB[0]];
        }else{
            [outputArray addObject:@""];
        }
        NSArray *dimC = thisObservation.activities[DimCKey];
        if (dimC) {
            int dimCCount = dimC.count;
            for (int c = 0; c <= 3; c++) {
                if (c < dimCCount) {
                    [outputArray addObject:dimC[c]];
                }else {
                    [outputArray addObject:@""];
                }
               }
        }else {
            [outputArray addObject:@""];
            [outputArray addObject:@""];
            [outputArray addObject:@""];
            [outputArray addObject:@""];
        }
    }
    
    NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:tempFileName];
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:tempFile append:NO];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:','];
    [writer writeLineOfFields:outputArray];
    
    [self composerSheetCSV];

}

#pragma mark - Core Plot Data Source Methods
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    CPTFill *areaGradientFill = [CPTFill fillWithColor:self.sliceColors[idx]];
    return areaGradientFill;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return dimOrderedTitles[index];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx {
    NSString *labelString = [[NSString alloc] init];
    if (plot == activityPieCPT) {
        //activity chart labels
        NSNumber *sum = [dimCountedArray valueForKeyPath:@"@sum.self"];
        float sliceValue = [dimCountedArray[idx] floatValue];
        int labelint = (sliceValue/ [sum floatValue]) * 100;
        labelString = [NSString stringWithFormat:@"%i%%", labelint];
    }else if (plot == timePieCPT) {
        //time chart labels
        if ([self.observerGapSwitch isOn]) {
            NSMutableArray *filling = [[NSMutableArray alloc] init];
            for (NSString *key in dimOrderedTitles) {
                [filling addObject:dimCombinedEvents[key]];
            }
            [filling addObject:dimCombinedEvents[@"Observer Gap"]];
            NSNumber *sum = [filling valueForKeyPath:@"@sum.self"];
            float sliceValue = [filling[idx] floatValue];
            int labelint = (sliceValue/ [sum floatValue]) * 100;
            labelString = [NSString stringWithFormat:@"%i%%", labelint];
        }else {
            NSMutableArray *filling = [[NSMutableArray alloc] init];
            for (NSString *key in dimOrderedTitles) {
                [filling addObject:dimCombinedEvents[key]];
            }
            NSNumber *sum = [filling valueForKeyPath:@"@sum.self"];
            float sliceValue = [filling[idx] floatValue];
            int labelint = (sliceValue/ [sum floatValue]) * 100;
            labelString = [NSString stringWithFormat:@"%i%%", labelint];
        }
    }
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", labelString]];
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontSize = 14.0f;
    textStyle.color = [CPTColor whiteColor];
    label.textStyle = textStyle;
    return label;
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    if (plotnumberOfRecords == flowPlot) {
        return flowTitles.count;
    }else if (plotnumberOfRecords == sPlot){
        return scatterAverage.count;
    }else if (plotnumberOfRecords == timePieCPT){
        return dimCombinedEvents.count;
    }else {
        if ([self.observerGapSwitch isOn]) {
            return  dimCombinedEvents.count - 1;
        }else {
            return dimCombinedEvents.count;
        }
    }
}
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSMutableArray *allDimFieldsReversed = [[NSMutableArray alloc] init];
    for (NSNumber *num in [allDimFields reverseObjectEnumerator]) {
        [allDimFieldsReversed addObject:num];
    }
    if (plot == sPlot) {
        // This method is actually called twice per point in the plot, one for the X and one for the Y value
        if(fieldEnum == CPTScatterPlotFieldX)
        {
            // Return x value.
            NSUInteger indexNew = index + 1;
            NSNumber *newIndex = [NSNumber numberWithInteger:indexNew];
            return newIndex;
        } else {
            // Return y value.
            return [scatterAverage objectAtIndex:index];
        }
    }
    /* Because someone didn't like the error bars
    if (plot == rPlot){
        if(fieldEnum == CPTRangePlotFieldX) {
        // Return x value.
        NSUInteger indexNew = index + 1;
        NSNumber *newIndex = [NSNumber numberWithInteger:indexNew];
        return newIndex;
    } else if(fieldEnum == CPTRangePlotFieldY) {
        // Return rest of values.
        return [scatterAverage objectAtIndex:index];
        
    } else if(fieldEnum == CPTRangePlotFieldLow){
        int a = [[scatterAverage objectAtIndex:index] intValue];
        int b = [[scatterMin objectAtIndex:index] intValue];
        NSNumber *num = [NSNumber numberWithInt:a - b];
        return num;
    }else if (fieldEnum == CPTRangePlotFieldHigh){
        int a = [[scatterAverage objectAtIndex:index] intValue];
        int b = [[scatterMax objectAtIndex:index] intValue];
        NSNumber *num = [NSNumber numberWithInt:b - a];
        return num;
    }else{
        return 0;
    }
    }
     */
     else if (plot == flowPlot){
        NSNumber *num = [[NSNumber alloc] init];
        if (fieldEnum == CPTBarPlotFieldBarTip) {
            num = flowEventTips[index];
        }else if (fieldEnum == CPTBarPlotFieldBarBase){
            num = flowEventsBases[index];
        }else{
            num = [NSNumber numberWithUnsignedLong:[allDimFieldsReversed indexOfObject:flowTitles[index]]+ 1];
        }
         return num;
     }else if (plot == timePieCPT){
         if ([self.observerGapSwitch isOn]) {
             NSMutableArray *filling = [[NSMutableArray alloc] init];
             for (NSString *key in dimOrderedTitles) {
                 [filling addObject:dimCombinedEvents[key]];
             }
             [filling addObject:dimCombinedEvents[@"Observer Gap"]];
             return [filling objectAtIndex:index];
         }else{
             NSMutableArray *filling = [[NSMutableArray alloc] init];
             for (NSString *key in dimOrderedTitles) {
                 [filling addObject:dimCombinedEvents[key]];
             }
             return [filling objectAtIndex:index];
         }
     }else{
        return [dimCountedArray objectAtIndex:index];
     }
}

#pragma mark - XYPieChart Data Source Methods
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    if ([self.observerGapSwitch isOn]) {
        if (pieChart != self.dimAActivityChart) {
            return dimCombinedEvents.count;
        }else{
            return dimCombinedEvents.count - 1;
        }
    }else{
        return dimCombinedEvents.count;
    }
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    if (pieChart == self.dimAActivityChart) {
        return [[dimCountedArray objectAtIndex:index] intValue];
    }else{
        if ([self.observerGapSwitch isOn]) {
            NSMutableArray *filling = [[NSMutableArray alloc] init];
            for (NSString *key in dimOrderedTitles) {
                [filling addObject:dimCombinedEvents[key]];
            }
            [filling addObject:dimCombinedEvents[@"Observer Gap"]];
            return [[filling objectAtIndex:index] intValue];
        }else{
            NSMutableArray *filling = [[NSMutableArray alloc] init];
            for (NSString *key in dimOrderedTitles) {
                [filling addObject:dimCombinedEvents[key]];
            }
            return [[filling objectAtIndex:index] intValue];
        }
    }
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    if(pieChart == self.dimATimeChart) {
      return [self.sliceColorsDim objectAtIndex:(index % self.sliceColorsDim.count)];
    }else {
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
    }
}

#pragma mark - XYPieChart Delegate Methods
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index {
//    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
//    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index {
//    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
    if (pieChart == self.dimAActivityChart) {
    self.selectedSliceLabelActivity.text = nil;
    }else {
        self.selectedSliceLabel.text = nil;
    }
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
//    NSLog(@"did select slice at index %lu",(unsigned long)index);
        if (pieChart == self.dimAActivityChart) {
            self.selectedSliceLabelActivity.text = [dimOrderedTitles objectAtIndex:index];
        }else {
            self.selectedSliceLabel.text = [dimOrderedTitles objectAtIndex:index];
        }
    }

- (void)viewDidDisappear: (BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
    [self setDimAActivityChart:nil];
    [self setDimATimeChart:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    if ([[segue identifier] isEqualToString:@"observationReviewToObservation"]){ObservationTableViewController *otvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        otvc.passingTeacher = self.passingTeacher;
        otvc.passingSchool = self.passingSchool;
        otvc.passingDistrict = self.passingDistrict;
        otvc.passingObservations = self.passingObservations;
    }
}

@end
