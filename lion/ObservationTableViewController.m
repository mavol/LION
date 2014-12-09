//
//  ObservationTableViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "ObservationTableViewController.h"

@interface ObservationTableViewController ()
{
    NSMutableDictionary *observationDataMDict;
    NSArray *keysMArray;
    NSArray *observationDateKeysArray;
}
@end

@implementation ObservationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
 
    //hides the UINavigationController's automatically instantiated back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    observationDataMDict = [[NSMutableDictionary alloc] init];
    keysMArray = [[NSArray alloc] init];
    keysMArray = [self.passingObservations allKeys];
    for (NSString *key in keysMArray) {
        ObservationData *obj =  [self.passingObservations objectForKey:key];
        if ([obj.teacherName isEqualToString:self.passingTeacher] && [obj.schoolName isEqualToString:self.passingSchool] && [obj.districtName isEqualToString:self.passingDistrict]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy MMMM dd 'at' HH:mm zzz"];
            NSString *stringFromDate = [formatter stringFromDate:obj.observationDate];
            [observationDataMDict setObject:key forKey:stringFromDate];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    observationDateMArray = [observationDateMArray valueForKeyPath:@"@distinctUnionOfObjects.ObservationDate"];
    
    //the code below will look at the array inside the [] for unique instances of "observationDate" and return them to a new array called observationDateMArray.
    //    observationDateMArray = [somearray valueForKeyPath:@"@distinctUnionOfObjects.observationDate"];
    
//    NSString *one = @"Observation 1";
//    
//    [observationArray addObject:one];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    observationDateKeysArray = [observationDataMDict allKeys];
    [observationDateKeysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return observationDateKeysArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    cell.textLabel.text = [[observationDataMDict allKeys] objectAtIndex:indexPath.row];

 
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *deleteMe = [observationDateKeysArray objectAtIndex:indexPath.row];

        
        
        //need to delete from passingObjects and save the pllist as well.
        [observationDataMDict removeObjectForKey:deleteMe];
        NSMutableString *observationMDictKey = [[NSMutableString alloc] init];
        [observationMDictKey appendString:self.passingDistrict];
        [observationMDictKey appendString:@"."];
        [observationMDictKey appendString:self.passingSchool];
        [observationMDictKey appendString:@"."];
        [observationMDictKey appendString:self.passingTeacher];
        [observationMDictKey appendString:@"."];
        [observationMDictKey appendString:deleteMe];
    

        [self.passingObservations removeObjectForKey:observationMDictKey];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
        [NSKeyedArchiver archiveRootObject:self.passingObservations toFile:fileName];
        
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    
    if([[segue identifier] isEqualToString:@"observationToObservationReview"]){
        ObservationReviewViewController *orvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSString *c = observationDataMDict.allValues[path.row];
        orvc.passingObservation = c;
        orvc.passingDistrict = self.passingDistrict;
        orvc.passingSchool = self.passingSchool;
        orvc.passingTeacher = self.passingTeacher;
        orvc.passingObservations = self.passingObservations;
        
        
    } if([[segue identifier] isEqualToString:@"observationToAddNew"]){
        AddNewViewController *avc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        avc.passingDistrict = self.passingDistrict;
        avc.passingSchool = self.passingSchool;
        avc.passingTeacher = self.passingTeacher;
        avc.passingObservations = self.passingObservations;
    }
        if ([[segue identifier] isEqualToString:@"observationToTeacher"])
            {TeacherTableViewController *ttvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
            ttvc.passingDistrict = self.passingDistrict;
            ttvc.passingSchool = self.passingSchool;
            ttvc.passingObservations = self.passingObservations;
            }
}



@end
