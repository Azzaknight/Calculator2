//
//  GraphViewController.h
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

// the model of the GraphicViewController is the program of the calculator which
// is the NSArray of the operands and operations!

// Should this be private? No this needs to be public as the CalculatorController needs to set it when segueing

@property (nonatomic, strong) id graphViewProgramStack;

@end
