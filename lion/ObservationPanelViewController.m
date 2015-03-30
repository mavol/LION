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

    NSMutableArray *eventsMArray;
    NSMutableString *combinedName;
    NSMutableDictionary *activitiesMDict;
    NSMutableDictionary *allActivitiesMDict;
    NSMutableDictionary *activityNotesMDict;
    NSMutableArray *allDimASwitches;
    NSArray *allDimATitles;
    NSMutableArray *allDimBSwitches;
    NSArray *allDimBTitles;
    NSMutableArray *allDimCSwitches;
    NSArray *allDimCTitles;
    ObservationData *currentObservation;
    int activityStartCount;
    NSTimer *aTimer;
    NSTimer *labelTimer;

    IBOutlet UIButton *dimA1;
    IBOutlet UIButton *dimA2;
    IBOutlet UIButton *dimA3;
    IBOutlet UIButton *dimA4;
    IBOutlet UIButton *dimA5;
    IBOutlet UIButton *dimA6;
    IBOutlet UIButton *dimA7;
    IBOutlet UIButton *dimA8;
    IBOutlet UIButton *dimA9;
    IBOutlet UIButton *dimA10;
    IBOutlet UIButton *dimA11;
    IBOutlet UIButton *dimA12;
    
    IBOutlet UIButton *dimB1;
    IBOutlet UIButton *dimB2;
    IBOutlet UIButton *dimB3;
    IBOutlet UIButton *dimB4;
    IBOutlet UIButton *dimB5;
    IBOutlet UIButton *dimB6;

    IBOutlet UIButton *dimC1;
    IBOutlet UIButton *dimC2;
    IBOutlet UIButton *dimC3;
    IBOutlet UIButton *dimC4;
    IBOutlet UIButton *dimC5;
    IBOutlet UIButton *dimC6;
    IBOutlet UIButton *dimC7;
    IBOutlet UIButton *dimC8;
    IBOutlet UIButton *dimC9;
    IBOutlet UIButton *dimC10;
    IBOutlet UIButton *dimC11;
    IBOutlet UIButton *dimC12;
    IBOutlet UIButton *dimC13;
    IBOutlet UIButton *dimC14;
    IBOutlet UIButton *dimC15;
    IBOutlet UIButton *dimC16;
    IBOutlet UIButton *dimC17;
    IBOutlet UIButton *dimC18;
    IBOutlet UIButton *dimC19;
    IBOutlet UIButton *dimC20;
    IBOutlet UIButton *dimC21;
    
    IBOutlet UIButton *startingGoalStated;
    IBOutlet UIButton *startingGoalWritten;
    IBOutlet UIButton *endingGoalStated;
    IBOutlet UIButton *endingGoalWritten;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endObservationButton;

    
}


@property (weak, nonatomic) IBOutlet UITextView *activityNotes;
@property (nonatomic) IBOutlet UILabel *transitioningTimerSeconds;
@property (nonatomic) IBOutlet UILabel *transitioningTimerMinutes;
@property (nonatomic) IBOutlet UILabel *transitioningTimerHours;
@property (nonatomic) IBOutlet UILabel *transitioning;

@end

@implementation ObservationPanelViewController

-(void)dimATouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
        [endObservationButton setImage:[UIImage imageNamed:@"endObsActive.png"] forState:UIControlStateNormal];
    }else {
        for (UIButton *x in allDimASwitches) {
            x.selected = NO;
        }
        btn.selected = YES;
        int both = 0;
        for (UIButton *x in allDimBSwitches) {
            if (x.selected == YES) {
                both = 1;
            }
        }
        if (both == 1) {
            endObservationButton.enabled = YES;
            [endObservationButton setImage:[UIImage imageNamed:@"newEvent.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)dimBTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == YES) {
        btn.selected = NO;
        [endObservationButton setImage:[UIImage imageNamed:@"endObsActive.png"] forState:UIControlStateNormal];
    }else {
        for (UIButton *x in allDimBSwitches) {
            x.selected = NO;
        }
        btn.selected = YES;
        int both = 0;
        for (UIButton *x in allDimASwitches) {
            if (x.selected == YES) {
                both = 1;
            }
        }
        if (both == 1) {
            endObservationButton.enabled = YES;
            [endObservationButton setImage:[UIImage imageNamed:@"newEvent.png"] forState:UIControlStateNormal];
        }
    }
}


- (IBAction)dimA1Touched:(id)sender {
    [self dimATouched:sender];
    }
- (IBAction)dimA2Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA3Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA4Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA5Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA6Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA7Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA8Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA9Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA10Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA11Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimA12Touched:(id)sender {
    [self dimATouched:sender];
}
- (IBAction)dimB1Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimB2Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimB3Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimB4Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimB5Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimB6Touched:(id)sender {
    [self dimBTouched:sender];
}
- (IBAction)dimC1Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
    btn.selected = YES;
    }
}
- (IBAction)dimC2Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC3Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC4Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC5Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC6Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC7Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC8Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC9Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC10Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC11Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC12Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC13Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC14Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC15Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC16Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC17Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC18Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC19Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC20Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)dimC21Touched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)startGoalStatedTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)startGoalWrittenTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)endGoalStatedTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)endGoalWrittenTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
- (IBAction)newActivity:(id)sender {
    if (activityStartCount == 0) {
        for (UIButton *x in allDimASwitches) {
            x.enabled = YES;
        }
        for (UIButton *x in allDimBSwitches) {
            x.enabled = YES;
        }
        for (UIButton *x in allDimCSwitches) {
            x.enabled = YES;
        }
        startingGoalWritten.enabled = YES;
        startingGoalStated.enabled = YES;
        endingGoalWritten.enabled = YES;
        endingGoalStated.enabled = YES;
        [startButton setImage:[UIImage imageNamed:@"timerBlank.png"] forState:UIControlStateNormal];
        [self startTimer];
        NSDate *activityStop = [NSDate date];
        [eventsMArray addObject:activityStop];
    }

    
    if (activityStartCount > 0) {
        NSString *keyA = [NSString stringWithFormat:@"DimA %02d", activityStartCount];
        NSMutableArray *multiSelectionA = [[NSMutableArray alloc] init];
        for (UIButton *x in allDimASwitches) {
            int location = [allDimASwitches indexOfObject:x];
            if ([x isSelected]) {
                [multiSelectionA addObject:allDimATitles[location]];
            }
            if (multiSelectionA.count > 0) {
                [activitiesMDict setObject:multiSelectionA forKey:keyA];
            }
        }
        
        NSString *keyB = [NSString stringWithFormat:@"DimB %02d",activityStartCount];
        NSMutableArray *multiSelectionB = [[NSMutableArray alloc] init];
        for (UIButton *x in allDimBSwitches) {
            int location = [allDimBSwitches indexOfObject:x];
            if ([x isSelected]) {
                [multiSelectionB addObject:allDimBTitles[location]];
            }
            if (multiSelectionB.count > 0) {
                [activitiesMDict setObject:multiSelectionB forKey:keyB];
            }
        }
        
        
        NSString *keyC = [NSString stringWithFormat:@"DimC %02d", activityStartCount];
        NSMutableArray *multiSelectionC = [[NSMutableArray alloc] init];
        for (UIButton *x in allDimCSwitches) {
            int location = [allDimCSwitches indexOfObject:x];
            if ([x isSelected]) {
                [multiSelectionC addObject:allDimCTitles[location]];
            }
        }
        if (multiSelectionC.count > 0) {
            [activitiesMDict setObject:multiSelectionC forKey:keyC];
        }
        
        NSString *checkKey = [NSString stringWithFormat:@"DimA %02d", activityStartCount];
        if (!activitiesMDict[checkKey]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You Must Make a Selection in the Instructional Events Category" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSString *checkKey = [NSString stringWithFormat:@"DimB %02d", activityStartCount];
            if (!activitiesMDict[checkKey]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You Must Make a Selection in the Grouping Category" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }else{

                [aTimer invalidate];
                aTimer = nil;
                [endObservationButton setImage:[UIImage imageNamed:@"endObsActive.png"] forState:UIControlStateNormal];
                
                NSDate *activityStop = [NSDate date];
                NSString *notesKey = [NSString stringWithFormat:@"%02d Activity Notes",activityStartCount];
                
                NSString *startingGoalStatedKey = [NSString stringWithFormat:@"%02d Starting Goal Stated",activityStartCount];
                NSString *startingGoalWrittenKey = [NSString stringWithFormat:@"%02d Starting Goal Written",activityStartCount];
                NSString *startingGoalStatedString = [NSString stringWithFormat:@"%hhd",startingGoalStated.isSelected];
                NSString *startingGoalWrittenString = [NSString stringWithFormat:@"%hhd",startingGoalWritten.isSelected];
                
                NSString *endingGoalStatedKey = [NSString stringWithFormat:@"%02d Ending Goal Stated",activityStartCount];
                NSString *endingGoalWrittenKey = [NSString stringWithFormat:@"%02d Ending Goal Written",activityStartCount];
                NSString *endingGoalStatedString = [NSString stringWithFormat:@"%hhd",endingGoalStated.isSelected];
                NSString *endingGoalWrittenString = [NSString stringWithFormat:@"%hhd",endingGoalWritten.isSelected];
                
                                
                [eventsMArray addObject:activityStop];
                [activityNotesMDict setObject:self.activityNotes.text forKey:notesKey];
                [activityNotesMDict setObject:startingGoalStatedString forKey:startingGoalStatedKey];
                [activityNotesMDict setObject:startingGoalWrittenString forKey:startingGoalWrittenKey];
                [activityNotesMDict setObject:endingGoalStatedString forKey:endingGoalStatedKey];
                [activityNotesMDict setObject:endingGoalWrittenString forKey:endingGoalWrittenKey];
                
                for (UIButton *x in allDimASwitches) {
                    [x setSelected:NO];
                }
                for (UIButton *x in allDimBSwitches) {
                    [x setSelected:NO];
                }
                for (UIButton *x in allDimCSwitches) {
                    [x setSelected:NO];
                }
                
                self.activityNotes.text = nil;
                startingGoalStated.selected = NO;
                startingGoalWritten.selected = NO;
                endingGoalStated.selected = NO;
                endingGoalWritten.selected = NO;
                
                [self.transitioningTimerSeconds setText:@""];
                [self.transitioningTimerMinutes setText:@""];
                [self.transitioningTimerHours setText:@""];
                [self.transitioning setText:@"Activity Saved"];
                labelTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideLabel:) userInfo:nil repeats:NO];
            }
        }
    }
    activityStartCount = activityStartCount + 1;
}

- (void) startTimer {
    [self.transitioningTimerSeconds setFont: [UIFont systemFontOfSize:45]];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountSeconds:) userInfo:nil repeats:YES];
    [self.transitioningTimerMinutes setText:@"00"];
    [self.transitioningTimerHours setText:@"00:"];
    [self.transitioning setText:@""];
    if (activityStartCount == 0){
        [self.transitioningTimerSeconds setText:@"00"];
    }else {
        [self.transitioningTimerSeconds setText:@"03"];

    }

}

- (IBAction)addObservationObject:(id)sender {
    if (activityStartCount > 0) {
        int dimASelected = 0;
        for (UIButton *x in allDimASwitches) {
            if ([x isSelected]) {
                dimASelected++;
            }
        }
        int dimBSelected = 0;
        for (UIButton *x in allDimBSwitches) {
            if ([x isSelected]) {
                dimBSelected++;
            }
        }
        if (dimASelected > 0 || dimASelected > 0) {
            [self newActivity:sender];
        }else{
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
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You must have at least 1 activity to save" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    activityStartCount = 0;

    allDimASwitches = [[NSMutableArray alloc] init];
    allDimBSwitches = [[NSMutableArray alloc] init];
    allDimCSwitches = [[NSMutableArray alloc] init];
    
    allDimATitles = [[NSArray alloc] initWithObjects:@"Concepts of Print",@"Phonological Awareness",@"Alphabetic Knowledge", @"Word Study/Phonics/Decoding", @"Spelling", @"Vocabulary", @"Fluency", @"Text Reading", @"Comprehension", @"Writing", @"Non Language Arts Activities", @"Transition", nil];
    allDimBTitles = [[NSArray alloc] initWithObjects:@"Whole Class",@"Small Group",@"Pairing",@"Independent",@"Individualized",@"Other: (describe in notes)",nil];
    allDimCTitles = [[NSArray alloc] initWithObjects:@"Audio-Tapes, CDs, etc.",@"Big Book (or similar)",@"Computers/iPads",@"Games, Puzzles, or Songs",@"Manipulatives",@"Oral Language",@"Pencil and Paper",@"Poster/Bulletin Board",@"Text-Basal",@"Text Decodable",@"Text-Pattern",@"Text-Student or Teacher Made",@"Text-Trade Book",@"Text-Unknown",@"Visuals-with Print",@"Visuals-without Print",@"Whiteboard, SmartBoard, etc.",@"Word Wall",@"Words out of Context",@"Workbooks/Worksheets",@"Other: (describe in notes)", nil];

    
    [allDimASwitches addObject:dimA1];
    [allDimASwitches addObject:dimA2];
    [allDimASwitches addObject:dimA3];
    [allDimASwitches addObject:dimA4];
    [allDimASwitches addObject:dimA5];
    [allDimASwitches addObject:dimA6];
    [allDimASwitches addObject:dimA7];
    [allDimASwitches addObject:dimA8];
    [allDimASwitches addObject:dimA9];
    [allDimASwitches addObject:dimA10];
    [allDimASwitches addObject:dimA11];
    [allDimASwitches addObject:dimA12];
    
    [allDimBSwitches addObject:dimB1];
    [allDimBSwitches addObject:dimB2];
    [allDimBSwitches addObject:dimB3];
    [allDimBSwitches addObject:dimB4];
    [allDimBSwitches addObject:dimB5];
    [allDimBSwitches addObject:dimB6];
    
    [allDimCSwitches addObject:dimC1];
    [allDimCSwitches addObject:dimC2];
    [allDimCSwitches addObject:dimC3];
    [allDimCSwitches addObject:dimC4];
    [allDimCSwitches addObject:dimC5];
    [allDimCSwitches addObject:dimC6];
    [allDimCSwitches addObject:dimC7];
    [allDimCSwitches addObject:dimC8];
    [allDimCSwitches addObject:dimC9];
    [allDimCSwitches addObject:dimC10];
    [allDimCSwitches addObject:dimC11];
    [allDimCSwitches addObject:dimC12];
    [allDimCSwitches addObject:dimC13];
    [allDimCSwitches addObject:dimC14];
    [allDimCSwitches addObject:dimC15];
    [allDimCSwitches addObject:dimC16];
    [allDimCSwitches addObject:dimC17];
    [allDimCSwitches addObject:dimC18];
    [allDimCSwitches addObject:dimC19];
    [allDimCSwitches addObject:dimC20];
    [allDimCSwitches addObject:dimC21];
    

    for (UIButton *x in allDimASwitches) {
        x.enabled = NO;
    }
    for (UIButton *x in allDimBSwitches) {
        x.enabled = NO;
    }
    for (UIButton *x in allDimCSwitches) {
        x.enabled = NO;
    }
    endObservationButton.enabled = NO;
    startingGoalWritten.enabled = NO;
    startingGoalStated.enabled = NO;
    endingGoalWritten.enabled = NO;
    endingGoalStated.enabled = NO;
    [self.transitioningTimerSeconds setText:@""];
    [self.transitioningTimerMinutes setText:@""];
    [self.transitioningTimerHours setText:@""];
    
    [[self.activityNotes layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.activityNotes layer] setBorderWidth:1];
    [[self.activityNotes layer] setCornerRadius:10];
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
    [self startTimer];
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
//    NSMutableArray *imgListArray = [NSMutableArray array];
//    for (int i=1; i <= 51; i++) {
//        NSString *strImgeName = [NSString stringWithFormat:@"tbg%03d.png", i];
//        UIImage *image = [UIImage imageNamed:strImgeName];
//        [imgListArray addObject:image];
//    }
//    for (int i=51; i > 0; i--) {
//        NSString *strImgeName = [NSString stringWithFormat:@"tbg%03d.png", i];
//        UIImage *image = [UIImage imageNamed:strImgeName];
//        [imgListArray addObject:image];
//    }
//    //set the image array inside a UIImageView object for animation
//    anim = [UIImage animatedImageWithImages:imgListArray duration:4];


   
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
    }
}

@end
