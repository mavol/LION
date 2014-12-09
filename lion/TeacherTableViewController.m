//
//  TeacherTableViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "TeacherTableViewController.h"

@interface TeacherTableViewController ()
{
    NSMutableArray *teacherMArray;
    NSArray *keysMArray;
}
@property (strong, nonatomic) IBOutlet UITableView *currentTeacher;

@end

@implementation TeacherTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hides the UINavigationController's automatically instantiated back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    teacherMArray = [[NSMutableArray alloc] init];
    keysMArray = [[NSArray alloc] init];
    keysMArray = [self.passingObservations allKeys];
    for (NSString *key in keysMArray) {
        ObservationData *obj =  [self.passingObservations objectForKey:key];
        if ([obj.schoolName isEqualToString:self.passingSchool] && [obj.districtName isEqualToString:self.passingDistrict]) {
            [teacherMArray addObject:obj];
        }
    }
    teacherMArray = [teacherMArray valueForKeyPath:@"@distinctUnionOfObjects.teacherName"];
    [teacherMArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //the code below will look at the array inside the [] for unique instances of "teacher" and return them to a new array called teacherMArray.
    //    teacherMArray = [somearray valueForKeyPath:@"@distinctUnionOfObjects.teacher"];
    
//    NSString *one = @"Mr. Jones";
//    [teacherArray addObject:one];
    
//    self->teacherArray = [self.passingSchool];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return teacherMArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [teacherMArray objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 
     if([[segue identifier] isEqualToString:@"teacherToObservation"]){
         ObservationTableViewController *ovc = [segue destinationViewController];
 // Pass the selected object to the new view controller.
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         NSString *c = teacherMArray[path.row];
         ovc.passingTeacher = c;
        [ovc setTitle:c];
         ovc.passingDistrict = self.passingDistrict;
         ovc.passingSchool = self.passingSchool;
         ovc.passingObservations = self.passingObservations;
 
 
        } if ([[segue identifier] isEqualToString:@"teacherToAddNew"])
        {AddNewViewController *avc = [segue destinationViewController];
// Pass the selected object to the new view controller.
            avc.passingDistrict = self.passingDistrict;
            avc.passingSchool = self.passingSchool;
            avc.passingObservations = self.passingObservations;
            
        }if ([[segue identifier] isEqualToString:@"teacherToSchool"])
        {SchoolTableViewController *stvc = [segue destinationViewController];
            stvc.passingObservations = self.passingObservations;
            stvc.passingDistrict = self.passingDistrict;
        }
 }


@end
