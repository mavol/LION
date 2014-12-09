//
//  DistrictTableViewController.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "DistrictTableViewController.h"


@interface DistrictTableViewController ()

{
    NSMutableArray *districtsMArray;
    NSArray *keysMArray;
}

@property (weak, nonatomic) IBOutlet UITableView *districtTableView;

@end

@implementation DistrictTableViewController



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
    
    //path for observations.plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent: @"observations.plist"];
    
    self.passingObservations = [[NSMutableDictionary alloc] init];
    
    //check if plist file exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        //Yes, the file exists, load in Observation Objects.
        self.passingObservations = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        districtsMArray = [[NSMutableArray alloc] init];
        keysMArray = [[NSArray alloc] init];
        keysMArray = [self.passingObservations allKeys];
        for (NSString *key in keysMArray) {
            ObservationData *obj =  [self.passingObservations objectForKey:key];
            [districtsMArray addObject:obj];
        }
        districtsMArray = [districtsMArray valueForKeyPath:@"@distinctUnionOfObjects.districtName"];
        [districtsMArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }else{
        NSLog(@"MATT! you need to enter a UIAlert here so user knows of loading error.");
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    


//    NSArray *districtsArray = [[NSArray alloc] initWithArray:districtsMArray];
//    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    return districtsMArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
//    ObservationData *currentDistrict = [districtsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [districtsMArray objectAtIndex:indexPath.row];
    
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


//Allows for swipe delete on UITableVeiw cell.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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
    if([[segue identifier] isEqualToString:@"districtToSchool"]){
        SchoolTableViewController *svc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSString *c = districtsMArray[path.row];
        svc.passingDistrict = c;
        [svc setTitle:c];
        svc.passingObservations = self.passingObservations;
        
    }else{
        AddNewViewController *avc = [segue destinationViewController];
        avc.passingObservations = self.passingObservations;
        
    }
}


@end
