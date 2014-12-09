//
//  AddNewViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/22/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "AddNewViewController.h"

@interface AddNewViewController ()

{

}
@property (weak, nonatomic) IBOutlet UITextField *currentDistrict;
@property (weak, nonatomic) IBOutlet UITextField *currentSchool;
@property (weak, nonatomic) IBOutlet UITextField *currentTeacher;
@property (weak, nonatomic) IBOutlet UITextField *currentGrade;
@property (weak, nonatomic) IBOutlet UITextField *numStudents;
@property (weak, nonatomic) IBOutlet UITextField *observerName;

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
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
