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


-(void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

-(void) awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialisation code
        [self setup];
    }
    return self;
}


-(CGPoint)myGraphOrigin
{
    if (!_myGraphOrigin.x && !_myGraphOrigin.y)
    {
        CGPoint midPoint;
        midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
        midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
        
        self.myGraphOrigin = midPoint;
    
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
        //_myGraphScale = self.contentScaleFactor;
       _myGraphScale = 10.0;
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

-(void)pan:(UIPanGestureRecognizer *) gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint movedTo = [gesture translationInView:self];
        movedTo.x += self.myGraphOrigin.x;
        movedTo.y += self.myGraphOrigin.y;
        [self setMyGraphOrigin:movedTo];
        [gesture setTranslation:CGPointZero inView:self];
    }
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // First draw the Axes using the Axes Drawer
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.myGraphOrigin scale:self.myGraphScale ];
    
    // - Get the bounds of the view to get the width in the current scale

    CGFloat xAxisOffset = self.myGraphOrigin.x/self.myGraphScale;
    CGFloat yAxisOffset = self.myGraphOrigin.y/self.myGraphScale;
    
    // BOOL to move the CGContextMoveToPoint to the starting point
    BOOL FirstPoint = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];

    CGContextBeginPath(context);
    
    for( int intx=0; intx < self.bounds.size.width; intx ++){
        
        // for intx = point 0, get the corresponding x in graph cordinate
        CGPoint graphPoint;
        graphPoint.x = intx/self.myGraphScale;
        graphPoint.x = graphPoint.x - xAxisOffset;
        
        // for the graph cordinaite point X get the graph cordinate point Y
        graphPoint.y = [self.dataSource valueOfYForValueX:graphPoint.x inGraphView:self];
        //NSLog(@"x = %g, y= %g", graphPoint.x, graphPoint.y);
        
        //for the graph cordinate point y - get the screen co-ordinates y
        graphPoint.y = yAxisOffset - graphPoint.y;
        graphPoint.y = graphPoint.y * self.myGraphScale;
        //NSLog(@"viewx = %d, viewyy= %g", intx, graphPoint.y);

        // if it's the first point then move the ContextPoint here
        // else draw a line to this point (fromt the last point!)
        if(FirstPoint)
        {
            CGContextMoveToPoint(context, intx, graphPoint.y);
            FirstPoint = NO; // No longet firstPoint!
            
        } else
        {
            CGContextAddLineToPoint(context, intx, graphPoint.y);
        }
        
    }
    
    CGContextStrokePath(context);
    
}


@end
