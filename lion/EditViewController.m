//
//  EditViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 6/3/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()  {
    ObservationData *thisObservation;
    NSMutableArray *activities;
    NSString *cellText;
}
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextView *prereviewSummary;
@property (weak, nonatomic) IBOutlet UISlider *prereviewRating;


@end

@implementation EditViewController

- (IBAction)reviewObservation:(id)sender {
    thisObservation.prereviewSummary = self.prereviewSummary.text;
    thisObservation.prereviewRating = [NSNumber numberWithFloat:self.prereviewRating.value];
    if (self.prereviewSummary.text.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You must write a pre-review summary before proceeding." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self save];
    [self performSegueWithIdentifier:@"editToObservationReview" sender:self];
}
- (IBAction)saveChanges:(id)sender {
    thisObservation.activityNotes[cellText] = self.notes.text;
    [self save];
}

- (void) save {
    self.passingObservations[self.passingObservation] = thisObservation;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
    [NSKeyedArchiver archiveRootObject:self.passingObservations toFile:fileName];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    thisObservation = self.passingObservations[self.passingObservation];
    NSMutableArray *tempActivities = [[NSMutableArray alloc] init];
    
    for (int x = 1; x <= thisObservation.events.count; x++) {
        NSString *key = [NSString stringWithFormat:@"DimA %02d", x];
        [tempActivities addObject:key];
        }
                                      
    activities = [[NSMutableArray alloc] init];
    for (NSString *x in tempActivities) {
        NSArray *tmpArray = thisObservation.activities[x];
        NSString *cellTitle = [NSString stringWithFormat:@"%@",tmpArray[0]];
        [activities addObject:cellTitle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return thisObservation.events.count / 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cellText = [NSString stringWithFormat:@"%02d Activity Notes",indexPath.row + 1];
//    NSLog(@"cell value: %@",cellText);
//    NSLog(@"activity Notes: %@", thisObservation.activityNotes[cellText]);
    [self.notes setText:thisObservation.activityNotes[cellText]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [activities objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    
    if([[segue identifier] isEqualToString:@"editToObservationReview"]){
        ObservationReviewViewController *orvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        
        orvc.passingObservation = self.passingObservation;
        orvc.passingObservations = self.passingObservations;
        orvc.passingDistrict = self.passingDistrict;
        orvc.passingSchool = self.passingSchool;
        orvc.passingTeacher = self.passingTeacher;
    }
}

@end
