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

@property (nonatomic, weak) IBOutlet GraphView * graphView; // outlet to GraphView to draw the graph in
@property (nonatomic, weak) IBOutlet UILabel * equationLabel; // outlet to label to write the equation in
@property (nonatomic, weak) IBOutlet UIToolbar * toolbar;   // outlet to toolbar to add the button to
@end

@implementation GraphViewController

////



- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    
    // set the title of the BarButton to self
    // then present the button to the SplitViewBarButtonitemPresenter
    barButtonItem.title = aViewController.title;
    
    NSMutableArray * toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray * toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems removeObject:barButtonItem];
    self.toolbar.items = toolbarItems;
}



////

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

-(void) storeScale:(CGFloat) scale inGraphView:(GraphView *) sender
{
    NSString *scaleKeyName = @"scale.graphView";
    [[NSUserDefaults standardUserDefaults] setFloat:scale forKey:scaleKeyName];
    
}


-(void) storeOrigin:(CGPoint) origin inGraphView:(GraphView *) sender
{
    NSString *xKeyName = @"originx.graphView";
    NSString *yKeyName = @"originy.graphView";
    
    [[NSUserDefaults standardUserDefaults] setFloat:origin.x forKey:xKeyName];
    [[NSUserDefaults standardUserDefaults] setFloat:origin.y forKey:yKeyName];
    
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
    
    // see if there are NSUserDefaults for the scale and the origin
    NSString* scaleKeyName = @"scale.graphView";
    NSString *xKeyName = @"originx.graphView";
    NSString *yKeyName = @"originy.graphView";
    
    CGFloat scale = [[NSUserDefaults standardUserDefaults] floatForKey:scaleKeyName];
    if(scale) self.graphView.myGraphScale = scale;
    
    CGFloat originx = [[NSUserDefaults standardUserDefaults] floatForKey:xKeyName];
    CGFloat originy = [[NSUserDefaults standardUserDefaults] floatForKey:yKeyName];
    
    if(originx && originy)
    {
        CGPoint origin;
        origin.x = originx;
        origin.y = originy;
        
        self.graphView.myGraphOrigin = origin;
    }
}

-(void)setGraphViewProgramStack:(id)graphViewProgramStack
{
    if (_graphViewProgramStack != graphViewProgramStack)
    {
        _graphViewProgramStack = graphViewProgramStack;
        [self equationToGraph];
        [self.graphView setNeedsDisplay];
    }
}


// ****************************  Inititalisation code that came with the class declaration


-(void)setup
{
    if(self.splitViewController)
    {
        self.splitViewController.delegate = self;
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Basically the view has just been rotated. Change the view's midpoint
    // and ask it to redraw itself
    
    CGPoint midPoint;
    midPoint.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width / 2;
    midPoint.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height / 2;
    
    self.graphView.myGraphOrigin = midPoint;
    //[self.graphView setNeedsDisplay];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
