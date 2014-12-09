//
//  SchoolTableViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "SchoolTableViewController.h"

@interface SchoolTableViewController ()
{
    NSMutableArray *schoolMArray;
    NSArray *keysArray;
}
@property (strong, nonatomic) IBOutlet UITableView *currentDistrict;

@end

@implementation SchoolTableViewController

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
    
    schoolMArray = [[NSMutableArray alloc] init];
    
        keysArray = [[NSArray alloc] init];
    keysArray = [self.passingObservations allKeys];
    for (NSString *key in keysArray) {
        ObservationData *obj =  [self.passingObservations objectForKey:key];
            if ([obj.districtName isEqualToString:self.passingDistrict]) {
            [schoolMArray addObject:obj];
        }
    }
    schoolMArray = [schoolMArray valueForKeyPath:@"@distinctUnionOfObjects.schoolName"];
    [schoolMArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    return schoolMArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
//    ObservationData *currentSchool = [schoolArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [currentSchool schoolName];
    cell.textLabel.text = [schoolMArray objectAtIndex:indexPath.row];

    
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
     
     if([[segue identifier] isEqualToString:@"schoolToTeacher"]){
         TeacherTableViewController *tvc = [segue destinationViewController];
         // Pass the selected object to the new view controller.
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         NSString *c = schoolMArray[path.row];
         tvc.passingSchool = c;
         [tvc setTitle:c];

         NSString *d = self.passingDistrict;
         tvc.passingDistrict = d;
         tvc.passingObservations = self.passingObservations;
         
         if([[segue identifier] isEqualToString:@"schoolToDistrict"]){
             DistrictTableViewController *dtvc = [segue destinationViewController];
             // Pass the selected object to the new view controller.
             dtvc.passingObservations = self.passingObservations;
         }
     } if([[segue identifier] isEqualToString:@"schoolToAddNew"])
        {AddNewViewController *avc = [segue destinationViewController];
         // Pass the selected object to the new view controller.
         avc.passingDistrict = self.passingDistrict;
         avc.passingObservations = self.passingObservations;
     }
 }



@end
