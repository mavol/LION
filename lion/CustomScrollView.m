//
//  CustomScrollView.m
//  lion
//
//  Created by Matthew Volkmann on 3/20/15.
//  Copyright (c) 2015 University of Iowa College of Education. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
}

@end
