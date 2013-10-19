//
//  GraphViewController.m
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"


@interface GraphViewController () <GraphVewDataSource>

@property (nonatomic, weak) IBOutlet GraphView * graphView;
@property (nonatomic, weak) IBOutlet UILabel * equationLabel;
@end

@implementation GraphViewController

/*
GraphViewDataSource Methods
 */

-(double) valueOfYForValueX:(double) x inGraphView:(GraphView *) sender
{
    
    NSDictionary * valueOfX = @{@"x":@(x)};
    id result = [CalculatorBrain runProgram:self.graphViewProgramStack withVariables:valueOfX];
    if ([result isKindOfClass:[NSNumber class]])
    {
        return [result doubleValue];
        
    }else return 0;
    
}


// Helper method to get the Equation String, the equation to Graph
-(void) equationToGraph
{
    NSString* equation =  [CalculatorBrain descriptionOfProgram:self.graphViewProgramStack];
    if ([equation isEqualToString:@""]) equation = @"0";
    self.equationLabel.text = [@"y = " stringByAppendingString:equation];
    
}




-(void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable the gesture recognisers here...
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(taps:)];
    tgr.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tgr];
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    self.graphView.dataSource = self;
    [self equationToGraph];
    
}

-(void)setGraphViewProgramStack:(id)graphViewProgramStack
{
    if (_graphViewProgramStack != graphViewProgramStack)
    {
        NSLog(@"Setting the graph view stack");
        _graphViewProgramStack = graphViewProgramStack;
        [self equationToGraph];
        [self.graphView setNeedsDisplay];
    }
}


// ****************************  Inititalisation code that came with the class declaration


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Basically the view has just been rotated. Change the view's midpoint
    // and ask it to redraw itself
    
    CGPoint midPoint;
    midPoint.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width / 2;
    midPoint.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height / 2;
    
    self.graphView.myGraphOrigin = midPoint;
    [self.graphView setNeedsDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
