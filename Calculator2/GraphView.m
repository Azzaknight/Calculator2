//
//  GraphView.m
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView  ()


@end

@implementation GraphView

@synthesize myGraphOrigin = _myGraphOrigin;
@synthesize myGraphScale = _myGraphScale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialisation code
    }
    return self;
}

-(CGPoint)myGraphOrigin
{
    if (! _myGraphOrigin.x || ! _myGraphOrigin.y)
    {
        CGPoint midPoint;
        midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
        midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
        _myGraphOrigin = midPoint;
    }
    return _myGraphOrigin;
}

-(void) setMyGraphOrigin:(CGPoint)myGraphOrigin
{
    
    if ((myGraphOrigin.x != _myGraphOrigin.x) && (myGraphOrigin.y != _myGraphOrigin.y))
    {
        _myGraphOrigin = myGraphOrigin;
        [self setNeedsDisplay];
    }
    
    
}

-(CGFloat) myGraphScale
{
    if(!_myGraphScale)
    {
        _myGraphScale = self.contentScaleFactor;
    }
    return _myGraphScale;
    
}

-(void)setMyGraphScale:(CGFloat)myGraphScale
{
    if(myGraphScale != _myGraphScale)
    {
        _myGraphScale = myGraphScale;
        [self setNeedsDisplay];
    }
}


-(void)taps:(UITapGestureRecognizer *) gesture
{
    gesture.numberOfTapsRequired = 3;
    
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        // 3 taps has happened... I will set this point to be my Origin
        self.myGraphOrigin = [gesture locationInView:self];
    }
    
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if( gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded)
    {
        self.myGraphScale *= gesture.scale; // adjust our scale
        gesture.scale = 1; // reset the scale so our changes are cumulative
    }
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // First draw the Axes using the Axes Drawer
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.myGraphOrigin scale:self.myGraphScale ];
    
    
    
}


@end
