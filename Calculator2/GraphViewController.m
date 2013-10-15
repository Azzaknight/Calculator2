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
-(NSString *) equationToGraph
{
    return [CalculatorBrain descriptionOfProgram:self.graphViewProgramStack];
    
}




-(void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable the gesture recognisers here...
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(taps:)];
    tgr.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tgr];
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    self.graphView.dataSource = self;
    
    NSString* equation = [self equationToGraph];
    if ([equation isEqualToString:@""]) equation = @"0";
    self.equationLabel.text = [@"y = " stringByAppendingString:equation];

    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
