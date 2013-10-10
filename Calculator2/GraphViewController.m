//
//  GraphViewController.m
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController ()

@property (nonatomic, weak) IBOutlet GraphView * graphView;

@end

@implementation GraphViewController

-(void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable the gesture recognisers here...
    [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(taps:)]];
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
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
