//
//  touchableCallOutsViewController.h
//  touchableCallOuts
//
//  Created by yasin turkoglu on 20.11.2012.
//  Copyright (c) 2012 yasin turkoglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class myCustomPinAnnotationClass;

@interface touchableCallOutsViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *myMapView;
    int pinCounter;
    myCustomPinAnnotationClass *myAnnotation;
    CLLocationCoordinate2D selectedPinCoordinate;
    int selectedPinNumber;
}

@property (strong, nonatomic) MKMapView *myMapView;
@property (strong, nonatomic) myCustomPinAnnotationClass *myAnnotation;
@end
