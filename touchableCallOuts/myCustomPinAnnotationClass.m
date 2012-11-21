//
//  myCustomPinAnnotationClass.m
//  touchableCallOuts
//
//  Created by yasin turkoglu on 20.11.2012.
//  Copyright (c) 2012 yasin turkoglu. All rights reserved.
//

#import "myCustomPinAnnotationClass.h"

@implementation myCustomPinAnnotationClass

@synthesize name = _name;
@synthesize description = _description;
@synthesize pinNum = _pinNum;
@synthesize coordinate = _coordinate;


- (id)initWithName:(NSString*)header description:(NSString*)description pinNum:(int)pinNum coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _name = [header copy];
        _description = [description copy];
        _pinNum = pinNum;
        _coordinate = coordinate;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _description;
}

- (int)tag {
    return _pinNum;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    //test touched point in map view
    //when hit test return nil callout close immediately by default
    UIView* hitView = [super hitTest:point withEvent:event];
    // if hittest return nil test touch point 
    if (hitView == nil){
        //dig view to find custom touchable view lately added by us
        for(UIView *firstView in self.subviews){
            if([firstView isKindOfClass:[NSClassFromString(@"UICalloutView") class]]){
                for(UIView *touchableView in firstView.subviews){
                    if([touchableView isKindOfClass:[UIView class]]){ //this is our touchable view class
                        //define touchable area 
                        CGRect touchableArea = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y, touchableView.frame.size.width, touchableView.frame.size.height);
                        //test touch point if in touchable area
                        if (CGRectContainsPoint(touchableArea, point)){
                            //if touch point is in touchable area return touchable view as a touched view
                            hitView = touchableView;
                        }
                    }
                }                
            }
        }
    }
    return hitView;
}

@end
