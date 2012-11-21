//
//  touchableCallOutsViewController.m
//  touchableCallOuts
//
//  Created by yasin turkoglu on 20.11.2012.
//  Copyright (c) 2012 yasin turkoglu. All rights reserved.
//

#import "touchableCallOutsViewController.h"
#import "myCustomPinAnnotationClass.h"

@interface touchableCallOutsViewController ()

@end



@implementation touchableCallOutsViewController

@synthesize myMapView;
@synthesize myAnnotation;

- (void)viewDidLoad
{
    
    //first we create mapview and add pin annotation
    
    myMapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    myMapView.delegate = self;
    MKCoordinateRegion region = {{0,0},{1.0,1.0}};
    region.center.latitude = 41.036651; //user defined
    region.center.longitude = 28.983870;//user defined
    [myMapView setRegion:region animated:YES];
    [self.view addSubview:myMapView];
    
    //we define long press recognizer for 2 seconds and add our map view to add new pin when you press 2 seconds on map view
    UILongPressGestureRecognizer *lngPrs = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleMyLongPress:)];
    lngPrs.minimumPressDuration = 2.0;
    [myMapView addGestureRecognizer:lngPrs];
    
    pinCounter = 1; //this variable hold pin numbers and increment 1 when new pin added.
    
    myAnnotation = [[myCustomPinAnnotationClass alloc]initWithName:[NSString stringWithFormat:@"Pin %i",pinCounter] description:@"touch here to see pin coordinates" pinNum:pinCounter coordinate:region.center];
    [myMapView addAnnotation:myAnnotation];
    
}

- (void)handleMyLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {

    }else{
        //when we press more than 2 seconds on map view UILongPressGestureRecognizer triggered this method and call our custom MKPinAnnotationView class and add annotation.
        CGPoint touchPoint = [gestureRecognizer locationInView:myMapView];
        CLLocationCoordinate2D touchMapCoordinate = [myMapView convertPoint:touchPoint toCoordinateFromView:myMapView];
        pinCounter++;
        myAnnotation = [[myCustomPinAnnotationClass alloc]initWithName:[NSString stringWithFormat:@"Pin %i",pinCounter] description:@"touch here to see pin coordinates" pinNum:pinCounter coordinate:touchMapCoordinate];
        [myMapView addAnnotation:myAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //when new annotation added by us, new annotation property will set here
    static NSString *identifier = @"myPins";
    if ([annotation isKindOfClass:[myCustomPinAnnotationClass class]]) {
        myCustomPinAnnotationClass *annotationView = (myCustomPinAnnotationClass *) [self.myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[myCustomPinAnnotationClass alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        myAnnotation = (myCustomPinAnnotationClass *)annotation;

        annotationView.pinColor = MKPinAnnotationColorGreen;       
        annotationView.enabled = YES;
        annotationView.draggable = YES;
        annotationView.canShowCallout = YES;
        [annotationView setSelected:YES animated:YES];
        return annotationView;
        
    }    
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    //if you select any annotation to show their callout sellected annotation pin number and coordinate setted and call findcallot method    
    myAnnotation = (myCustomPinAnnotationClass *)view.annotation;
    selectedPinCoordinate = myAnnotation.coordinate;
    selectedPinNumber = myAnnotation.pinNum;
    [self findCallOut:myMapView];
}


- (void)findCallOut:(UIView *)node
{
    //this method dig our mapview with for loop until find callout view class named "UICalloutView"
    
    if([node isKindOfClass:[NSClassFromString(@"UICalloutView") class]]){
        
        //this method trigered together with callout open animation.
        
        //in UICalloutView we have callout bubble image
        //we dig it with for loop to find this image height
        float buubleHeight = 0.0;
        for(UIImageView *bubbleComponents in node.subviews){
            //when we find callout bubble image take height to set our touchable area height
            buubleHeight = bubbleComponents.frame.size.height;
            break;
        }
        
        
        
        //this method triger with callout open animation as I said before
        //ant this bouncing open animation distort actual size of callout view
        //so when this happens we also get transform value of callout view and make proportion to find exact sizes.
        CGFloat nodeTransformRatio = node.transform.a;
        CGFloat calculatedWidth = roundf(node.frame.size.width / nodeTransformRatio);
        CGFloat calculatedHeight = roundf(buubleHeight / nodeTransformRatio);
        
        //now create a new UIView and sized according to callout view.
        UIView *touchableView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, calculatedWidth, calculatedHeight)];
        touchableView.userInteractionEnabled = YES;
        
        //we add new single tap gesture recognizer to triger desired method when users touching to the callout
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething)];
        [touchableView addGestureRecognizer:singleTap];
        //and finaly we add this newly created view in callout view to receive touches.
        [node addSubview:touchableView];

    }else{
        //loop self until find a "UICalloutView"
        for(UIView *child in node.subviews){
            [self findCallOut:child];
        }
    }
}

- (void)doSomething
{
    //this method call allert view our preseted variables when users touch callout view.
    UIAlertView *alertHolder = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You're touched the Pin %i CallOut",selectedPinNumber] message:[NSString stringWithFormat:@"lat : %f\nlong : %f",selectedPinCoordinate.latitude,selectedPinCoordinate.longitude] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok",nil];
    [alertHolder show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
