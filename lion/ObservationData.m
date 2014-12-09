//
//  ObservationData.m
//  ICErOberservingTool
//
//  Created by Ashley Rila on 4/21/14.
//  Copyright (c) 2014 University of Iowa. All rights reserved.
//

#import "ObservationData.h"



@implementation ObservationData

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
        _districtName = [decoder decodeObjectForKey:@"district"];
        _schoolName = [decoder decodeObjectForKey:@"school"];
        _teacherName = [decoder decodeObjectForKey:@"teacher"];
        _observationDate = [decoder decodeObjectForKey:@"observationDate"];
        _events = [decoder decodeObjectForKey:@"events"];
        _activities = [decoder decodeObjectForKey:@"activities"];
        _activityNotes = [decoder decodeObjectForKey:@"activityNotes"];
        _prereviewSummary = [decoder decodeObjectForKey:@"prereviewSummary"];
        _postreviewSummary = [decoder decodeObjectForKey:@"postreviewSummary"];
        _prereviewRating = [decoder decodeObjectForKey:@"prereviewRating"];
        _postreviewRating = [decoder decodeObjectForKey:@"postreviewRating"];
        _numStudents = [decoder decodeObjectForKey:@"numStudents"];
        _observerName = [decoder decodeObjectForKey:@"observerName"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.districtName forKey:@"district"];
    [encoder encodeObject:self.schoolName forKey:@"school"];
    [encoder encodeObject:self.teacherName forKey:@"teacher"];
    [encoder encodeObject:self.observationDate forKey:@"observationDate"];
    [encoder encodeObject:self.events forKey:@"events"];
    [encoder encodeObject:self.activities forKey:@"activities"];
    [encoder encodeObject:self.activityNotes forKey:@"activityNotes"];
    [encoder encodeObject:self.prereviewSummary forKey:@"prereviewSummary"];
    [encoder encodeObject:self.postreviewSummary forKey:@"postreviewSummary"];
    [encoder encodeObject:self.prereviewRating forKey:@"prereviewRating"];
    [encoder encodeObject:self.postreviewRating forKey:@"postreviewRating"];
    [encoder encodeObject:self.numStudents forKey:@"numStudents"];
    [encoder encodeObject:self.observerName forKey:@"observerName"];
    
}

@end
