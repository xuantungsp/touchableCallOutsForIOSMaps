//
//  myCustomPinAnnotationClass.h
//  touchableCallOuts
//
//  Created by yasin turkoglu on 20.11.2012.
//  Copyright (c) 2012 yasin turkoglu. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface myCustomPinAnnotationClass : MKPinAnnotationView <MKAnnotation> {
    NSString *_name;
    NSString *_description;
    int _pinNum;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *description;
@property (nonatomic, readonly) int pinNum;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)header description:(NSString*)description pinNum:(int)pinNum coordinate:(CLLocationCoordinate2D)coordinate;

@end
