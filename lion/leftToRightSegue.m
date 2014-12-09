//
//  leftToRightSegue.m
//  lion
//
//  Created by Matthew Volkmann on 10/17/14.
//  Copyright (c) 2014 University of Iowa College of Education. All rights reserved.
//

#import "leftToRightSegue.h"

@implementation leftToRightSegue

-(void)perform {
    
    __block UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    __block UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //    UIInterfaceOrientation *orient = [UIApplication sharedApplication].statusBarOrientation;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        
    {
        transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        
    }
    
    else if (deviceOrientation == UIDeviceOrientationPortrait)
        
    {
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    }
    
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        
    {
        transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        
    {
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    }
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    
}



@end