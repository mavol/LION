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
    NSString *notesKey;
    int tableTouchCount;
    NSMutableArray *allDimASwitches;
    NSArray *allDimATitles;
    NSMutableArray *allDimBSwitches;
    NSArray *allDimBTitles;
    NSMutableArray *allDimCSwitches;
    NSArray *allDimCTitles;
    int previousSelection;
    UITextView *activeField;
    
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
    __weak IBOutlet UIView *preReviewSummaryView;
    
    
    

}
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextView *prereviewSummary;
@property (weak, nonatomic) IBOutlet UISlider *prereviewRating;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property CGPoint currentSVoffset;


@end

@implementation EditViewController

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    activeField = nil;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    self.currentSVoffset = self.scrollView.contentOffset;
    NSDictionary* info = [aNotification userInfo];
    CGRect keyPadFrame=[[UIApplication sharedApplication].keyWindow convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view];
    CGSize kbSize =keyPadFrame.size;
    CGRect activeRect=[self.view convertRect:activeField.frame fromView:activeField.superview];
    CGRect aRect = self.view.bounds;
    aRect.size.height -= (kbSize.height);
    
    CGPoint origin =  activeRect.origin;
//    origin.y -= self.scrollView.contentOffset.y;
    origin.y += activeField.frame.size.height;
    if (!CGRectContainsPoint(aRect, origin)) {
        CGPoint scrollPoint = CGPointMake(0.0,CGRectGetMaxY(activeRect)-(aRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentOffset = self.currentSVoffset;
}

- (IBAction)dimA1Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA1.selected = YES;
}
- (IBAction)dimA2Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA2.selected = YES;
}
- (IBAction)dimA3Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA3.selected = YES;
}
- (IBAction)dimA4Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA4.selected = YES;
}
- (IBAction)dimA5Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA5.selected = YES;
}
- (IBAction)dimA6Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA6.selected = YES;
}
- (IBAction)dimA7Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA7.selected = YES;
}
- (IBAction)dimA8Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA8.selected = YES;
}
- (IBAction)dimA9Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA9.selected = YES;
}
- (IBAction)dimA10Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA10.selected = YES;
}
- (IBAction)dimA11Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA11.selected = YES;
}
- (IBAction)dimA12Touched:(id)sender {
    for (UIButton *x in allDimASwitches) {
        x.selected = NO;
    }
    dimA12.selected = YES;
}
- (IBAction)dimB1Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB1.selected = YES;
}
- (IBAction)dimB2Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB2.selected = YES;
}
- (IBAction)dimB3Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB3.selected = YES;
}
- (IBAction)dimB4Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB4.selected = YES;
}
- (IBAction)dimB5Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB5.selected = YES;
}
- (IBAction)dimB6Touched:(id)sender {
    for (UIButton *x in allDimBSwitches) {
        x.selected = NO;
    }
    dimB6.selected = YES;
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


- (IBAction)reviewObservation:(id)sender {
    [[self.prereviewSummary layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.prereviewSummary layer] setBorderWidth:1];
    [[self.prereviewSummary layer] setCornerRadius:10];
    
    [[preReviewSummaryView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[preReviewSummaryView layer] setBorderWidth:1];
    [[preReviewSummaryView layer] setCornerRadius:10];
    preReviewSummaryView.layer.masksToBounds = NO;
    preReviewSummaryView.layer.shadowOffset = CGSizeMake(15, 20);
    preReviewSummaryView.layer.shadowRadius = 5;
    preReviewSummaryView.layer.shadowOpacity = 0.3;
    
    thisObservation.prereviewSummary = self.prereviewSummary.text;
    preReviewSummaryView.hidden = NO;
    [self save];
}

- (IBAction)done:(id)sender {
    if (self.prereviewSummary.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You must write a pre-review summary before proceeding." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self performSegueWithIdentifier:@"editToObservationReview" sender:self];
        [self save];
    }
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
    if (tableTouchCount > 0) {
        [self.view endEditing:YES];
        thisObservation.activityNotes[notesKey] = self.notes.text;
        [self save];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    tableTouchCount = 0;
    activeField = [[UITextView alloc] init];
    activeField.delegate = self;
    self.notes.delegate = self;
    // Do any additional setup after loading the view.
    thisObservation = self.passingObservations[self.passingObservation];
    NSMutableArray *tempActivities = [[NSMutableArray alloc] init];
    
    for (int x = 1; x <= thisObservation.events.count + 1; x++) {
        NSString *key = [NSString stringWithFormat:@"DimA %02d", x];
        [tempActivities addObject:key];
        }
                                      
    activities = [[NSMutableArray alloc] init];
    for (NSString *x in tempActivities) {
        NSArray *tmpArray = thisObservation.activities[x];
        NSString *cellTitle = [NSString stringWithFormat:@"%@",tmpArray[0]];
        [activities addObject:cellTitle];
    }
    
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
    startingGoalWritten.enabled = NO;
    startingGoalStated.enabled = NO;
    endingGoalWritten.enabled = NO;
    endingGoalStated.enabled = NO;
    
    [[self.notes layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.notes layer] setBorderWidth:1];
    [[self.notes layer] setCornerRadius:10];
    self.notes.editable = NO;
    
    self.scrollView.contentOffset = CGPointMake(0, 20);
    
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
    return thisObservation.events.count - 1;
}

-(void)autoSaveActivityNotes {
    thisObservation.activityNotes[notesKey] = self.notes.text;
    
    NSString *keyA = [NSString stringWithFormat:@"DimA %02d", previousSelection];
    NSMutableArray *multiSelectionA = [[NSMutableArray alloc] init];
    for (UIButton *x in allDimASwitches) {
        int location = [allDimASwitches indexOfObject:x];
        if ([x isSelected]) {
            [multiSelectionA addObject:allDimATitles[location]];
        }
        if (multiSelectionA.count > 0) {
            [thisObservation.activities setObject:multiSelectionA forKey:keyA];
        }
    }
    
    NSString *keyB = [NSString stringWithFormat:@"DimB %02d",previousSelection];
    NSMutableArray *multiSelectionB = [[NSMutableArray alloc] init];
    for (UIButton *x in allDimBSwitches) {
        int location = [allDimBSwitches indexOfObject:x];
        if ([x isSelected]) {
            [multiSelectionB addObject:allDimBTitles[location]];
        }
        if (multiSelectionB.count > 0) {
            [thisObservation.activities setObject:multiSelectionB forKey:keyB];
        }
    }
    
    
    NSString *keyC = [NSString stringWithFormat:@"DimC %02d", previousSelection];
    NSMutableArray *multiSelectionC = [[NSMutableArray alloc] init];
    for (UIButton *x in allDimCSwitches) {
        int location = [allDimCSwitches indexOfObject:x];
        if ([x isSelected]) {
            [multiSelectionC addObject:allDimCTitles[location]];
        }
    }
    if (multiSelectionC.count > 0) {
        [thisObservation.activities setObject:multiSelectionC forKey:keyC];
    }

    
    [self save];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableTouchCount > 0) {
        [self autoSaveActivityNotes];
    }
    self.notes.editable = YES;
    previousSelection = indexPath.row + 1;
    tableTouchCount = tableTouchCount + 1;
    
    for (UIButton *x in allDimASwitches) {
        x.enabled = YES;
        x.selected = NO;
    }
    for (UIButton *x in allDimBSwitches) {
        x.enabled = YES;
        x.selected = NO;
    }
    for (UIButton *x in allDimCSwitches) {
        x.enabled = YES;
        x.selected = NO;
    }
    startingGoalWritten.enabled = YES;
    startingGoalWritten.selected = NO;
    startingGoalStated.enabled = YES;
    startingGoalStated.selected = NO;
    endingGoalWritten.enabled = YES;
    endingGoalWritten.selected = NO;
    endingGoalStated.enabled = YES;
    endingGoalStated.selected = NO;
    
    notesKey = [NSString stringWithFormat:@"%02d Activity Notes",indexPath.row + 1];
    [self.notes setText:thisObservation.activityNotes[notesKey]];
    
    NSString *dimAKey = [NSString stringWithFormat:@"DimA %02d",indexPath.row + 1];
    NSArray *dimAArray = [NSArray arrayWithArray:thisObservation.activities[dimAKey]];
    int dimAIndex = [allDimATitles indexOfObject:dimAArray[0]];
    UIButton *btnA = allDimASwitches[dimAIndex];
    btnA.selected = YES;
    NSString *dimBKey = [NSString stringWithFormat:@"DimB %02d",indexPath.row + 1];
    NSArray *dimBArray = thisObservation.activities[dimBKey];
    int dimBIndex = [allDimBTitles indexOfObject:dimBArray[0]];
    UIButton *btnB = allDimBSwitches[dimBIndex];
    btnB.selected = YES;
    NSString *dimCKey = [NSString stringWithFormat:@"DimC %02d",indexPath.row + 1];
    NSArray *dimCArray = thisObservation.activities[dimCKey];
    for (int x = 0; x < dimCArray.count; x++) {
        int dimCIndex = [allDimCTitles indexOfObject:dimCArray[x]];
        UIButton *btnC = allDimCSwitches[dimCIndex];
        btnC.selected = YES;
    }
    NSString *goalsKey = [NSString stringWithFormat:@"%02d Starting Goal Stated",indexPath.row + 1];
    NSString *btnState = [NSString stringWithFormat:@"%@",thisObservation.activityNotes[goalsKey]];
    if ([btnState isEqualToString:@"1"]) {
        startingGoalStated.selected = YES;
    }
    goalsKey = [NSString stringWithFormat:@"%02d Starting Goal Written",indexPath.row + 1];
    btnState = [NSString stringWithFormat:@"%@",thisObservation.activityNotes[goalsKey]];
    if ([btnState isEqualToString:@"1"]) {
        startingGoalWritten.selected = YES;
    }
    goalsKey = [NSString stringWithFormat:@"%02d Ending Goal Stated",indexPath.row + 1];
    btnState = [NSString stringWithFormat:@"%@",thisObservation.activityNotes[goalsKey]];
    if ([btnState isEqualToString:@"1"]) {
        endingGoalStated.selected = YES;
    }
    goalsKey = [NSString stringWithFormat:@"%02d Ending Goal Written",indexPath.row + 1];
    btnState = [NSString stringWithFormat:@"%@",thisObservation.activityNotes[goalsKey]];
    if ([btnState isEqualToString:@"1"]) {
        endingGoalWritten.selected = YES;
    }

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
