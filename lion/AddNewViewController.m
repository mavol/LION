//
//  AddNewViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/22/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "AddNewViewController.h"
#import <MessageUI/MessageUI.h>


@interface AddNewViewController () <MFMailComposeViewControllerDelegate>

{
    NSMutableArray *districtsMArray;
    NSArray *keysArray;
    NSString *fileName;
    ObservationData *thisObservation;
    NSString *tempFileName;
    NSArray *pickerOptions;
}
@property (weak, nonatomic) IBOutlet UITextField *currentDistrict;
@property (weak, nonatomic) IBOutlet UITextField *currentSchool;
@property (weak, nonatomic) IBOutlet UITextField *currentTeacher;
@property (weak, nonatomic) IBOutlet UITextField *currentGrade;
@property (weak, nonatomic) IBOutlet UITextField *numStudents;
@property (weak, nonatomic) IBOutlet UITextField *observerName;
@property (weak, nonatomic) IBOutlet UIView *tableViewView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *oldNew;
@property (weak, nonatomic) IBOutlet UIButton *exObButton;
@property (weak, nonatomic) IBOutlet UITextField *gradeField;
@property (strong, nonatomic) UIPickerView *gradePicker;


@end

@implementation AddNewViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

- (IBAction)cancelExport:(id)sender {
    [self.tableViewView setHidden:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //set delegate for keyboard dismissal.
    self.currentDistrict.delegate = self;
    self.currentSchool.delegate = self;
    self.currentTeacher.delegate = self;
    self.currentGrade.delegate = self;
    self.numStudents.delegate = self;
    self.observerName.delegate = self;
    
    
    //pass in values from UITableview structure if available.
    self.currentDistrict.text = _passingDistrict;
    self.currentSchool.text = _passingSchool;
    self.currentTeacher.text = _passingTeacher;
    self.numStudents.text = self.passingNumStudents;
    self.observerName.text = self.passingObserverName;
    
    [[self.tableViewView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.tableViewView layer] setBorderWidth:1];
    [[self.tableViewView layer] setCornerRadius:10];
    self.tableViewView.layer.masksToBounds = NO;
    self.tableViewView.layer.shadowOffset = CGSizeMake(15, 20);
    self.tableViewView.layer.shadowRadius = 5;
    self.tableViewView.layer.shadowOpacity = 0.3;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    districtsMArray = [[NSMutableArray alloc] init];
    keysArray = [[NSArray alloc] init];
    fileName = [[NSString alloc] init];
    
    //path for observations.plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
    
    self.passingObservations = [[NSMutableDictionary alloc] init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        self.passingObservations = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        keysArray = [self.passingObservations allKeys];
    }else{
        self.exObButton.enabled = NO;
    }
    [self.tableViewView setHidden:YES];
    
    thisObservation = [[ObservationData alloc] init];
    
    self.gradePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.gradePicker setDataSource:self];
    [self.gradePicker setDelegate:self];
    
    
    self.gradePicker.showsSelectionIndicator = YES;
    self.gradeField.inputView = self.gradePicker;
    pickerOptions = [[NSArray alloc] initWithObjects:@"Kindergarten", @"1st Grade", @"2nd Grade", @"3rd Grade", @"4th Grade", @"5th Grade", @"6th Grade", @"7th Grade", @"8th Grade", @"9th Grade", @"10th Grade", @"11th Grade", @"12th Grade" , nil];

    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 13;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return pickerOptions[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.gradeField.text = pickerOptions[row];
//    [self.gradeField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//return key dismisses keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return keysArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ObservationData *obs = [[ObservationData alloc] init];
    NSString *obsKey = [[NSString alloc] initWithFormat:@"%@",keysArray[indexPath.row] ];
    obs = self.passingObservations[obsKey];
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    NSMutableArray *headingsArray = [[NSMutableArray alloc] init];
    
    if ([self.oldNew selectedSegmentIndex] == 0) {

        NSNumber *countEvents = [NSNumber numberWithInt:obs.events.count / 2];
        
        tempFileName = [[NSProcessInfo processInfo] globallyUniqueString];
        [outputArray addObject:tempFileName];
        
        if (obs.districtName) {
            [outputArray addObject:obs.districtName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.schoolName) {
            [outputArray addObject:obs.schoolName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.teacherName) {
            [outputArray addObject:obs.teacherName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.prereviewRating) {
            [outputArray addObject:obs.prereviewRating];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.prereviewSummary) {
            [outputArray addObject:obs.prereviewSummary];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.postreviewRating) {
            [outputArray addObject:obs.postreviewRating];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.postreviewSummary) {
            [outputArray addObject:obs.postreviewSummary];
        }else{
            [outputArray addObject:@"No Object"];
        }

        [outputArray addObject:countEvents];
        
        if (obs.numStudents) {
            [outputArray addObject:obs.numStudents];
        }else{
            [outputArray addObject:@"No Object"];
        }
        
        if (obs.observerName) {
            [outputArray addObject:obs.observerName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        
        headingsArray = [[NSMutableArray alloc] initWithObjects:@"Temporary File Identifier", @"School District", @"School", @"Teacher", @"PreReview Rating", @"PreReview Summary", @"PostReview Rating", @"PostReview Summary", @"Number of Instructional Events", @"Number of Students", @"Observer Name", nil];
        
        NSDate *start = [[NSDate alloc] init];
        NSDate *end = [[NSDate alloc] init];
        NSMutableArray *actLength = [[NSMutableArray alloc] init];
        int count = 0;
        end = nil;
        start = nil;
        for (NSDate *x in obs.events) {
            if (count % 2 == 0) {
                start = x;
            }else{
                end = x;
            }
            count++;
            if (start && end) {
                NSString *startString = [NSDateFormatter localizedStringFromDate:start dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
                [outputArray addObject:startString];
                [headingsArray addObject:[NSString stringWithFormat:@"%02d Start Date and Time",count / 2]];
                NSString *endString = [NSDateFormatter localizedStringFromDate:end dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
                [headingsArray addObject:[NSString stringWithFormat:@"%02d End Date and Time",count /2]];
                [outputArray addObject:endString];
                NSTimeInterval lessonSpan = [end timeIntervalSinceDate:start];
                double lessonSpanSeconds = lessonSpan;
                [actLength addObject:[NSNumber numberWithDouble:lessonSpanSeconds]];
                end = nil;
                start = nil;
            }
        }
        //enter data for individual events
        for (int x = 0; x < countEvents.intValue; x++) {
            NSString *DimAKey = [NSString stringWithFormat:@"DimA %02d",x + 1];
            NSString *DimBKey = [NSString stringWithFormat:@"DimB %02d",x + 1];
            NSString *DimCKey = [NSString stringWithFormat:@"DimC %02d",x + 1];
            NSString *activityNotesKey = [NSString stringWithFormat:@"%02d Activity Notes",x + 1];
            NSString *startingGoalKey = [NSString stringWithFormat:@"%02d Starting Goal",x + 1];
            NSString *startingGoalModeKey = [NSString stringWithFormat:@"%02d Starting Goal Mode",x + 1];
            NSString *endingGoalKey = [NSString stringWithFormat:@"%02d Ending Goal",x + 1];
            NSString *endingGoalModeKey = [NSString stringWithFormat:@"%02d Ending Goal Mode",x + 1];
            [outputArray addObject:actLength[x]];
            NSString *eventLengthStr = [NSString stringWithFormat:@"%02d Activity Length",x + 1];
            [headingsArray addObject:eventLengthStr];
            [outputArray addObject:obs.activityNotes[activityNotesKey]];
            NSString *activityNotesString = [NSString stringWithFormat:@"%02d Activity Notes",x + 1];
            [headingsArray addObject:activityNotesString];
            [outputArray addObject:obs.activityNotes[startingGoalKey]];
            [headingsArray addObject:startingGoalKey];
            [outputArray addObject:obs.activityNotes[startingGoalModeKey]];
            [headingsArray addObject:startingGoalModeKey];
            [outputArray addObject:obs.activityNotes[endingGoalKey]];
            [headingsArray addObject:endingGoalKey];
            [outputArray addObject:obs.activityNotes[endingGoalModeKey]];
            [headingsArray addObject:endingGoalModeKey];
            NSArray *dimA = obs.activities[DimAKey];
            if (dimA) {
                [outputArray addObject:dimA[0]];
            }else{
                [outputArray addObject:@"No Object"];
            }
            NSString *headingA = [NSString stringWithFormat:@"%02d Instructional Event", x + 1];
            [headingsArray addObject:headingA];
            NSArray *dimB = obs.activities[DimBKey];
            if (dimB) {
                [outputArray addObject:dimB[0]];
            }else{
                [outputArray addObject:@"No Object"];
            }
            NSString *headingB = [NSString stringWithFormat:@"%02d Grouping", x + 1];
            [headingsArray addObject:headingB];
            NSArray *dimC = obs.activities[DimCKey];
            NSString *headingC1 = [NSString stringWithFormat:@"%02d Materials 1",x + 1];
            NSString *headingC2 = [NSString stringWithFormat:@"%02d Materials 2",x + 1];
            NSString *headingC3 = [NSString stringWithFormat:@"%02d Materials 3",x + 1];
            NSString *headingC4 = [NSString stringWithFormat:@"%02d Materials 4",x + 1];
            [headingsArray addObject:headingC1];
            [headingsArray addObject:headingC2];
            [headingsArray addObject:headingC3];
            [headingsArray addObject:headingC4];
            
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
    }else{
        NSNumber *countEvents = [NSNumber numberWithInt:obs.events.count - 1];
        
        tempFileName = [[NSProcessInfo processInfo] globallyUniqueString];
        [outputArray addObject:tempFileName];
        
        if (obs.districtName) {
            [outputArray addObject:obs.districtName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.schoolName) {
            [outputArray addObject:obs.schoolName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.teacherName) {
            [outputArray addObject:obs.teacherName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.prereviewSummary) {
            [outputArray addObject:obs.prereviewSummary];
        }else{
            [outputArray addObject:@"No Object"];
        }
        if (obs.postreviewSummary) {
            [outputArray addObject:obs.postreviewSummary];
        }else{
            [outputArray addObject:@"No Object"];
        }
        
        [outputArray addObject:countEvents];
        
        if (obs.numStudents) {
            [outputArray addObject:obs.numStudents];
        }else{
            [outputArray addObject:@"No Object"];
        }
        
        if (obs.observerName) {
            [outputArray addObject:obs.observerName];
        }else{
            [outputArray addObject:@"No Object"];
        }
        
        headingsArray = [[NSMutableArray alloc] initWithObjects:@"Temporary File Identifier", @"School District", @"School", @"Teacher", @"PreReview Summary", @"PostReview Summary", @"Number of Instructional Events", @"Number of Students", @"Observer Name", nil];
        
        NSDate *start = [[NSDate alloc] init];
        NSDate *end = [[NSDate alloc] init];
        int count = 1;
        NSMutableArray *events = [[NSMutableArray alloc] init];
        for (int x = 0; x < obs.events.count; x++){
            if (x == 0) {
                start = obs.events[x];
            }else{
                end = obs.events[x];
            }if (start && end) {
                NSString *startString = [NSDateFormatter localizedStringFromDate:start dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
                [outputArray addObject:startString];
                NSString *startHeadingsString = [NSString stringWithFormat:@"%02d Event Start", count];
                [headingsArray addObject:startHeadingsString];
                NSString *endHeadingsString = [NSString stringWithFormat:@"%02d Event End", count];
                [headingsArray addObject:endHeadingsString];
                NSString *endString = [NSDateFormatter localizedStringFromDate:end dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
                [outputArray addObject:endString];
                NSString *key = [NSString stringWithFormat:@"%02d Event Length",count];
                [headingsArray addObject:key];
                NSTimeInterval lessonSpan = [end timeIntervalSinceDate:start];
                [events addObject:[NSNumber numberWithDouble:lessonSpan]];
                start = end;
                count++;
            }
            NSString *DimAKey = [NSString stringWithFormat:@"DimA %02d",x + 1];
            NSString *DimBKey = [NSString stringWithFormat:@"DimB %02d",x + 1];
            NSString *DimCKey = [NSString stringWithFormat:@"DimC %02d",x + 1];
            NSString *activityNotesKey = [NSString stringWithFormat:@"%02d Activity Notes",x + 1];
            NSString *startingGoalKey = [NSString stringWithFormat:@"%02d Starting Goal",x + 1];
            NSString *startingGoalModeKey = [NSString stringWithFormat:@"%02d Starting Goal Mode",x + 1];
            NSString *endingGoalKey = [NSString stringWithFormat:@"%02d Ending Goal",x + 1];
            NSString *endingGoalModeKey = [NSString stringWithFormat:@"%02d Ending Goal Mode",x + 1];
            [outputArray addObject:events[x]];
            NSString *eventLengthStr = [NSString stringWithFormat:@"%02d Activity Length",x + 1];
            [headingsArray addObject:eventLengthStr];
            [outputArray addObject:obs.activityNotes[activityNotesKey]];
            NSString *activityNotesString = [NSString stringWithFormat:@"%02d Activity Notes",x + 1];
            [headingsArray addObject:activityNotesString];
            [outputArray addObject:obs.activityNotes[startingGoalKey]];
            [headingsArray addObject:startingGoalKey];
            [outputArray addObject:obs.activityNotes[startingGoalModeKey]];
            [headingsArray addObject:startingGoalModeKey];
            [outputArray addObject:obs.activityNotes[endingGoalKey]];
            [headingsArray addObject:endingGoalKey];
            [outputArray addObject:obs.activityNotes[endingGoalModeKey]];
            [headingsArray addObject:endingGoalModeKey];
            NSArray *dimA = obs.activities[DimAKey];
            [outputArray addObject:dimA[0]];
            NSString *headingA = [NSString stringWithFormat:@"%02d Instructional Event", x + 1];
            [headingsArray addObject:headingA];
            NSArray *dimB = obs.activities[DimBKey];
            [outputArray addObject:dimB[0]];
            NSString *headingB = [NSString stringWithFormat:@"%02d Grouping", x + 1];
            [headingsArray addObject:headingB];
            NSArray *dimC = obs.activities[DimCKey];
            NSString *headingC1 = [NSString stringWithFormat:@"%02d Materials 1",x + 1];
            NSString *headingC2 = [NSString stringWithFormat:@"%02d Materials 2",x + 1];
            NSString *headingC3 = [NSString stringWithFormat:@"%02d Materials 3",x + 1];
            NSString *headingC4 = [NSString stringWithFormat:@"%02d Materials 4",x + 1];
            [headingsArray addObject:headingC1];
            [headingsArray addObject:headingC2];
            [headingsArray addObject:headingC3];
            [headingsArray addObject:headingC4];
            
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
    }
    
    NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:tempFileName];
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:tempFile append:NO];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:','];
    [writer writeLineOfFields:headingsArray];
    [writer writeLineOfFields:outputArray];
    
    [self mailComposer:tempFile];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [keysArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)exportObservation:(id)sender {
    [self.tableViewView setHidden:NO];
}

-(void)mailComposer:(NSString *)filename {
    [self.tableViewView setHidden:YES];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Observation Data"];
    
    // Attach pdf to the email
    
    NSMutableData *myData =  [NSMutableData dataWithContentsOfFile:filename];
    if ([self.oldNew selectedSegmentIndex] == 0) {
        [mailComposer addAttachmentData:myData mimeType:@"text/csv" fileName:@"Old LION Observation Data.csv"];
    }else{
        [mailComposer addAttachmentData:myData mimeType:@"text/csv" fileName:@"New LION Observation Data.csv"];
    }
    
    // Fill out the email body text
    NSString *emailBody = @"Please see the attached observation data.";
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
        
    if ([[segue identifier] isEqualToString:@"addNewToObservationPanel"]){
        
    ObservationPanelViewController *opvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
    
        NSString *a = [[self currentDistrict] text];
        opvc.passingDistrict = a;
        opvc.passingSchool = self.currentSchool.text;
        opvc.passingTeacher = self.currentTeacher.text;
        opvc.passingGrade = self.currentGrade.text;
        opvc.passingNumStudents = self.numStudents.text;
        opvc.passingObserverName = self.observerName.text;
        opvc.passingObservations = self.passingObservations;
    }
}



@end
