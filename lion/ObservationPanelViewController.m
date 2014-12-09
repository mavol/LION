//
//  ObservationPanelViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/23/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "ObservationPanelViewController.h"


@interface ObservationPanelViewController ()
{
//    NSMutableDictionary *observationDataMDict;
    NSMutableArray *eventsMArray;
    NSMutableString *combinedName;
    NSMutableDictionary *activitiesMDict;
    NSMutableDictionary *allActivitiesMDict;
    NSMutableDictionary *activityNotesMDict;
    NSMutableDictionary *allDimASwitches;
    NSMutableDictionary *allDimBSwitches;
    NSMutableDictionary *allDimCSwitches;
    ObservationData *currentObservation;
    int activityStartCount;
//    int toggleTOCount;
    NSTimer *aTimer;
    NSTimer *labelTimer;
    UIImage *anim;
    IBOutlet UISwitch *dimA1;
    IBOutlet UISwitch *dimA2;
    IBOutlet UISwitch *dimA3;
    IBOutlet UISwitch *dimA4;
    IBOutlet UISwitch *dimA5;
    IBOutlet UISwitch *dimA6;
    IBOutlet UISwitch *dimA7;
    IBOutlet UISwitch *dimA8;
    IBOutlet UISwitch *dimA9;
    IBOutlet UISwitch *dimA10;
    IBOutlet UISwitch *dimA11;
    IBOutlet UISwitch *dimA12;
    
    IBOutlet UISwitch *dimB1;
    IBOutlet UISwitch *dimB2;
    IBOutlet UISwitch *dimB3;
    IBOutlet UISwitch *dimB4;
    IBOutlet UISwitch *dimB5;
    IBOutlet UISwitch *dimB6;

    IBOutlet UISwitch *dimC1;
    IBOutlet UISwitch *dimC2;
    IBOutlet UISwitch *dimC3;
    IBOutlet UISwitch *dimC4;
    IBOutlet UISwitch *dimC5;
    IBOutlet UISwitch *dimC6;
    IBOutlet UISwitch *dimC7;
    IBOutlet UISwitch *dimC8;
    IBOutlet UISwitch *dimC9;
    IBOutlet UISwitch *dimC10;
    IBOutlet UISwitch *dimC11;
    IBOutlet UISwitch *dimC12;
    IBOutlet UISwitch *dimC13;
    IBOutlet UISwitch *dimC14;
    IBOutlet UISwitch *dimC15;
    IBOutlet UISwitch *dimC16;
    IBOutlet UISwitch *dimC17;
    IBOutlet UISwitch *dimC18;
    IBOutlet UISwitch *dimC19;
    IBOutlet UISwitch *dimC20;
    IBOutlet UISwitch *dimC21;
    
    IBOutlet UISegmentedControl *toggleTO;
    
}


@property (weak, nonatomic) IBOutlet UITextView *activityNotes;
@property (nonatomic) IBOutlet UILabel *transitioningTimerSeconds;
@property (nonatomic) IBOutlet UILabel *transitioningTimerMinutes;
@property (nonatomic) IBOutlet UILabel *transitioningTimerHours;
@property (nonatomic) IBOutlet UILabel *transitioning;
@property (weak, nonatomic) IBOutlet UIImageView *activityTimerAnimate;
@property (weak, nonatomic) IBOutlet UISwitch *startingGoalSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *startingGoalMode;
@property (weak, nonatomic) IBOutlet UISwitch *endingGoalSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *endingGoalMode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleTOValue;
@property (weak, nonatomic) IBOutlet UILabel *dimA1Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA2Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA3Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA4Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA5Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA6Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA7Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA8Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA9Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA10Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA11Value;
@property (weak, nonatomic) IBOutlet UILabel *dimA12Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB1Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB2Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB3Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB4Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB5Value;
@property (weak, nonatomic) IBOutlet UILabel *dimB6OtherValue;
@property (weak, nonatomic) IBOutlet UILabel *dimC1V;
@property (weak, nonatomic) IBOutlet UILabel *dimC2V;
@property (weak, nonatomic) IBOutlet UILabel *dimC3V;
@property (weak, nonatomic) IBOutlet UILabel *dimC4V;
@property (weak, nonatomic) IBOutlet UILabel *dimC5V;
@property (weak, nonatomic) IBOutlet UILabel *dimC6V;
@property (weak, nonatomic) IBOutlet UILabel *dimC7V;
@property (weak, nonatomic) IBOutlet UILabel *dimC8V;
@property (weak, nonatomic) IBOutlet UILabel *dimC9V;
@property (weak, nonatomic) IBOutlet UILabel *dimC10V;
@property (weak, nonatomic) IBOutlet UILabel *dimC11V;
@property (weak, nonatomic) IBOutlet UILabel *dimC12V;
@property (weak, nonatomic) IBOutlet UILabel *dimC13V;
@property (weak, nonatomic) IBOutlet UILabel *dimC14V;
@property (weak, nonatomic) IBOutlet UILabel *dimC15V;
@property (weak, nonatomic) IBOutlet UILabel *dimC16V;
@property (weak, nonatomic) IBOutlet UILabel *dimC17V;
@property (weak, nonatomic) IBOutlet UILabel *dimC18V;
@property (weak, nonatomic) IBOutlet UILabel *dimC19V;
@property (weak, nonatomic) IBOutlet UILabel *dimC20V;
@property (weak, nonatomic) IBOutlet UILabel *dimC21OtherV;

@end

@implementation ObservationPanelViewController

- (IBAction)newActivity:(id)sender {
    [self.activityTimerAnimate setImage:anim];
    activityStartCount = activityStartCount + 1;
    NSDate *activityStart = [NSDate date];
    [eventsMArray addObject:activityStart];
    [self.transitioningTimerSeconds setFont: [UIFont systemFontOfSize:45]];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountSeconds:) userInfo:nil repeats:YES];
    [self.transitioningTimerSeconds setText:@"00"];
    [self.transitioningTimerMinutes setText:@"00"];
    [self.transitioningTimerHours setText:@"00:"];
    [self.transitioning setText:@""];
    
    for (NSString *flip in allDimASwitches) {
        UISwitch *value = [allDimASwitches objectForKey:flip];
        value.enabled = YES;
    }
    for (UISwitch *flip in allDimBSwitches) {
        UISwitch *value = [allDimBSwitches objectForKey:flip];
        value.enabled = YES;
    }
    for (UISwitch *flip in allDimCSwitches) {
        UISwitch *value = [allDimCSwitches objectForKey:flip];
        value.enabled = YES;
    }
}
- (IBAction)endActivity:(id)sender {
    if (aTimer) {
        NSMutableArray *multiSelectionA = [[NSMutableArray alloc] init];
        NSString *keyA = [NSString stringWithFormat:@"DimA %02d", activityStartCount];
        for (NSString *flip in allDimASwitches) {
            UISwitch *value = [allDimASwitches objectForKey:flip];
            if ([value isOn] == 1) {
                [multiSelectionA addObject:flip];
            }
        }
        [activitiesMDict setObject:multiSelectionA forKey:keyA];
        NSMutableArray *multiSelectionB = [[NSMutableArray alloc] init];
        NSString *keyB = [NSString stringWithFormat:@"DimB %02d", activityStartCount];
        for (NSString *flip in allDimBSwitches) {
            UISwitch *value = [allDimBSwitches objectForKey:flip];
            if ([value isOn] == 1) {
                [multiSelectionB addObject:flip];
            }
        }
        if (multiSelectionB.count > 0) {
            [activitiesMDict setObject:multiSelectionB forKey:keyB];
        }
        NSString *keyC = [NSString stringWithFormat:@"DimC %02d", activityStartCount];
        NSMutableArray *multiSelectionC = [[NSMutableArray alloc] init];
        for (NSString *flip in allDimCSwitches) {
            UISwitch *value = [allDimCSwitches objectForKey:flip];
            if ([value isOn] == 1) {
                [multiSelectionC addObject:flip];
            }
        }
        if (multiSelectionC.count > 0) {
            [activitiesMDict setObject:multiSelectionC forKey:keyC];
        }
        
//        [allActivitiesMDict setObject:activitiesMDict forKey:[NSString stringWithFormat:@"%02d", activityStartCount]];
        NSString *checkKey = [NSString stringWithFormat:@"DimA %02d", activityStartCount];
        if (activitiesMDict[checkKey]) {
            UIImage *stillImage = [UIImage imageNamed:@"tbg051.png"];
            [self.activityTimerAnimate setImage:stillImage];
            [aTimer invalidate];
            aTimer = nil;
            [self.transitioning setText:@"Activity Saved"];
            labelTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideLabel:) userInfo:nil repeats:NO];
            NSDate *activityStop = [NSDate date];
            NSString *notesKey = [NSString stringWithFormat:@"%02d Activity Notes",activityStartCount];
            NSString *startingGoalValue = [NSString stringWithFormat:@"%d",self.startingGoalSwitch.isOn];
            NSString *startingGoalKey = [NSString stringWithFormat:@"%02d Starting Goal",activityStartCount];
            NSUInteger startingSegmentIndex = self.startingGoalMode.selectedSegmentIndex;
            NSUInteger endingSegmentIndex = self.endingGoalMode.selectedSegmentIndex;
            NSString *startingGoalModeValue = [NSString stringWithFormat:@"%lu",(unsigned long)startingSegmentIndex];
            NSString *startingGoalModeKey = [NSString stringWithFormat:@"%02d Starting Goal Mode",activityStartCount];
            NSString *endingGoalValue = [NSString stringWithFormat:@"%d",self.endingGoalSwitch.isOn];
            NSString *endingGoalKey = [NSString stringWithFormat:@"%02d Ending Goal",activityStartCount];
            NSString *endingGoalModeValue = [NSString stringWithFormat:@"%lu",(unsigned long)endingSegmentIndex];
            
            NSString *endingGoalModeKey = [NSString stringWithFormat:@"%02d Ending Goal Mode",activityStartCount];
            [eventsMArray addObject:activityStop];
            [self.transitioningTimerSeconds setText:@""];
            [self.transitioningTimerMinutes setText:@""];
            [self.transitioningTimerHours setText:@""];
            [activityNotesMDict setObject:self.activityNotes.text forKey:notesKey];
            [activityNotesMDict setObject:startingGoalValue forKey:startingGoalKey];
            [activityNotesMDict setObject:startingGoalModeValue forKey:startingGoalModeKey];
            [activityNotesMDict setObject:endingGoalValue forKey:endingGoalKey];
            [activityNotesMDict setObject: endingGoalModeValue forKey:endingGoalModeKey];
            
            for (UISwitch *flip in allDimASwitches) {
                UISwitch *value = [allDimASwitches objectForKey:flip];
                [value setOn:NO animated:YES];
                value.enabled = NO;
            }
            for (UISwitch *flip in allDimBSwitches) {
                UISwitch *value = [allDimBSwitches objectForKey:flip];
                [value setOn:NO animated:YES];
                value.enabled = NO;
            }
            for (UISwitch *flip in allDimCSwitches) {
                UISwitch *value = [allDimCSwitches objectForKey:flip];
                [value setOn:NO animated:YES];
                value.enabled = NO;
            }
            
            self.activityNotes.text = nil;
            [self.startingGoalSwitch setOn:NO animated:YES];
            [self.endingGoalSwitch setOn:NO animated:YES];

        
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You Must Make at Least 1 Selection in Dimension A" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
    }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"I'm sorry, the timer isn't running yet." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)addObservationObject:(id)sender {
    if (activityStartCount > 0 && !aTimer) {
        
        //concatenated string for key for object
        combinedName = [[NSMutableString alloc] init];
        [combinedName appendString:self.passingDistrict];
        [combinedName appendString:@"."];
        [combinedName appendString:self.passingSchool];
        [combinedName appendString:@"."];
        [combinedName appendString:self.passingTeacher];
        [combinedName appendString:@"."];
        NSDate *todaysDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy MMMM dd 'at' HH:mm zzz"];
        NSString *stringFromDate = [formatter stringFromDate:todaysDate];
        [combinedName appendString:stringFromDate];
        
        //Creating the currentObservation Object and adding it to a mutable dictionary of Observations.
        currentObservation.observationDate = todaysDate;
        currentObservation.events = eventsMArray;
        currentObservation.activities = activitiesMDict;
        currentObservation.activityNotes = activityNotesMDict;
        currentObservation.numStudents = self.passingNumStudents;
        currentObservation.observerName = self.passingObserverName;

        
        //add it to Mdict
        self.passingObservations[combinedName] = currentObservation;
        //archive to plist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
        [NSKeyedArchiver archiveRootObject:self.passingObservations toFile:fileName];
        [self preliminarySummary];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You must have an activity to save or stop the current event to save." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    activityStartCount = 0;

    allDimASwitches = [[NSMutableDictionary alloc] init];
    allDimBSwitches = [[NSMutableDictionary alloc] init];
    allDimCSwitches = [[NSMutableDictionary alloc] init];
    
    [allDimASwitches setObject:dimA1 forKey:self.dimA1Value.text];
    [allDimASwitches setObject:dimA2 forKey:self.dimA2Value.text];
    [allDimASwitches setObject:dimA3 forKey:self.dimA3Value.text];
    [allDimASwitches setObject:dimA4 forKey:self.dimA4Value.text];
    [allDimASwitches setObject:dimA5 forKey:self.dimA5Value.text];
    [allDimASwitches setObject:dimA6 forKey:self.dimA6Value.text];
    [allDimASwitches setObject:dimA7 forKey:self.dimA7Value.text];
    [allDimASwitches setObject:dimA8 forKey:self.dimA8Value.text];
    [allDimASwitches setObject:dimA9 forKey:self.dimA9Value.text];
    [allDimASwitches setObject:dimA10 forKey:self.dimA10Value.text];
    [allDimASwitches setObject:dimA11 forKey:self.dimA11Value.text];
    [allDimASwitches setObject:dimA12 forKey:self.dimA12Value.text];
    
    [allDimBSwitches setObject:dimB1 forKey:self.dimB1Value.text];
    [allDimBSwitches setObject:dimB2 forKey:self.dimB2Value.text];
    [allDimBSwitches setObject:dimB3 forKey:self.dimB3Value.text];
    [allDimBSwitches setObject:dimB4 forKey:self.dimB4Value.text];
    [allDimBSwitches setObject:dimB5 forKey:self.dimB5Value.text];
    [allDimBSwitches setObject:dimB6 forKey:self.dimB6OtherValue.text];
    
    [allDimCSwitches setObject:dimC1 forKey:self.dimC1V.text];
    [allDimCSwitches setObject:dimC2 forKey:self.dimC2V.text];
    [allDimCSwitches setObject:dimC3 forKey:self.dimC3V.text];
    [allDimCSwitches setObject:dimC4 forKey:self.dimC4V.text];
    [allDimCSwitches setObject:dimC5 forKey:self.dimC5V.text];
    [allDimCSwitches setObject:dimC6 forKey:self.dimC6V.text];
    [allDimCSwitches setObject:dimC7 forKey:self.dimC7V.text];
    [allDimCSwitches setObject:dimC8 forKey:self.dimC8V.text];
    [allDimCSwitches setObject:dimC9 forKey:self.dimC9V.text];
    [allDimCSwitches setObject:dimC10 forKey:self.dimC10V.text];
    [allDimCSwitches setObject:dimC11 forKey:self.dimC11V.text];
    [allDimCSwitches setObject:dimC12 forKey:self.dimC12V.text];
    [allDimCSwitches setObject:dimC13 forKey:self.dimC13V.text];
    [allDimCSwitches setObject:dimC14 forKey:self.dimC14V.text];
    [allDimCSwitches setObject:dimC15 forKey:self.dimC15V.text];
    [allDimCSwitches setObject:dimC16 forKey:self.dimC16V.text];
    [allDimCSwitches setObject:dimC17 forKey:self.dimC17V.text];
    [allDimCSwitches setObject:dimC18 forKey:self.dimC18V.text];
    [allDimCSwitches setObject:dimC19 forKey:self.dimC19V.text];
    [allDimCSwitches setObject:dimC20 forKey:self.dimC20V.text];
    [allDimCSwitches setObject:dimC21 forKey:self.dimC21OtherV.text];
    
    for (NSString *flip in allDimASwitches) {
        UISwitch *value = [allDimASwitches objectForKey:flip];
        value.enabled = NO;
    }
    for (UISwitch *flip in allDimBSwitches) {
        UISwitch *value = [allDimBSwitches objectForKey:flip];
        value.enabled = NO;
    }
    for (UISwitch *flip in allDimCSwitches) {
        UISwitch *value = [allDimCSwitches objectForKey:flip];
        value.enabled = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//touching outside any text box dismisses keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)hideLabel:(NSTimer *) labelTimer{
        [self.transitioning setText:@""];
        [self.transitioningTimerSeconds setText:@"00"];
        [self.transitioningTimerMinutes setText:@"00"];
        [self.transitioningTimerHours setText:@"00:"];
}

- (void) preliminarySummary {

    [self performSegueWithIdentifier:@"observationPanelToEdit" sender:self];
    
}

-(void)timerCountSeconds:(NSTimer *) aTimer {
    self.transitioningTimerSeconds.text = [NSString stringWithFormat:@"%02d",[self.transitioningTimerSeconds.text  intValue] + 1];
    if ([self.transitioningTimerSeconds.text isEqualToString:@"60"]) {
        self.transitioningTimerSeconds.text = @"00";
        self.transitioningTimerMinutes.text = [NSString stringWithFormat:@"%02d",[self.transitioningTimerMinutes.text intValue] + 1];
        if ([self.transitioningTimerMinutes.text isEqualToString:@"60"]) {
            self.transitioningTimerMinutes.text = @"00";
            self.transitioningTimerHours.text = [NSString stringWithFormat:@"%02d",[self.transitioningTimerHours.text intValue] + 1];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentObservation = [[ObservationData alloc] init];
    currentObservation.districtName = self.passingDistrict;
    currentObservation.schoolName = self.passingSchool;
    currentObservation.teacherName = self.passingTeacher;
    currentObservation.grade = self.passingGrade;
    eventsMArray = [[NSMutableArray alloc] init];
    activityNotesMDict = [[NSMutableDictionary alloc] init];
    activitiesMDict = [[NSMutableDictionary alloc] init];
    allActivitiesMDict = [[NSMutableDictionary alloc] init];
    NSString *placeholderText = [NSString stringWithFormat:@"placeholder"];
    activityNotesMDict[@"placeholderKey"] = placeholderText;
    
    self.transitioningTimerSeconds = [[UILabel alloc] initWithFrame:CGRectMake(170, 27, 215, 72)];
    [self.transitioningTimerSeconds setBackgroundColor:[UIColor clearColor]];
    [self.transitioningTimerSeconds setText:@"00"];
    [self.transitioningTimerSeconds setFont: [UIFont systemFontOfSize:45]];
    [self.view addSubview:self.transitioningTimerSeconds];
    
    self.transitioningTimerMinutes = [[UILabel alloc] initWithFrame:CGRectMake(107, 25, 215, 72)];
    [self.transitioningTimerMinutes setBackgroundColor:[UIColor clearColor]];
    [self.transitioningTimerMinutes setText:@"00"];
    [self.transitioningTimerMinutes setFont: [UIFont systemFontOfSize:50]];
    [self.view addSubview:self.transitioningTimerMinutes];
    
    self.transitioningTimerHours = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 215, 72)];
    [self.transitioningTimerHours setBackgroundColor:[UIColor clearColor]];
    [self.transitioningTimerHours setText:@"00:"];
    [self.transitioningTimerHours setFont: [UIFont systemFontOfSize:50]];
    [self.view addSubview:self.transitioningTimerHours];
    
    self.transitioning = [[UILabel alloc] initWithFrame:CGRectMake(33, 27, 215, 72)];
    [self.transitioning setBackgroundColor:[UIColor clearColor]];
    [self.transitioning setText:@""];
    [self.transitioning setFont: [UIFont systemFontOfSize:32]];
    [self.view addSubview:self.transitioning];
    
    //add timer animation images to an array for animation
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=1; i <= 51; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"tbg%03d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        [imgListArray addObject:image];
    }
    for (int i=51; i > 0; i--) {
        NSString *strImgeName = [NSString stringWithFormat:@"tbg%03d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        [imgListArray addObject:image];
    }
    //set the image array inside a UIImageView object for animation
    anim = [UIImage animatedImageWithImages:imgListArray duration:4];


   
    //hides the UINavigationController's automatically instantiated back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewDidDisappear: (BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    
    if([[segue identifier] isEqualToString:@"observationPanelToEdit"]){
        EditViewController *evc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        
        evc.passingObservation = combinedName;
        evc.passingObservations = self.passingObservations;
        evc.passingDistrict = self.passingDistrict;
        evc.passingSchool = self.passingSchool;
        evc.passingTeacher = self.passingTeacher;

        
    } if([[segue identifier] isEqualToString:@"observationPanelToAddNew"]){
        AddNewViewController *avc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        avc.passingObservations = self.passingObservations;
        avc.passingDistrict = self.passingDistrict;
        avc.passingSchool = self.passingSchool;
        avc.passingTeacher = self.passingTeacher;
    }
}

@end
