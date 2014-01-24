//
//  GraphFavouritesViewController.h
//  Calculator2
//
//  Created by Pamamarch on 10/11/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphFavouritesViewController;

@protocol GraphsFavouritesViewControllerDelegate <NSObject>

@optional
-(void) graphFavouritesViewController:(GraphFavouritesViewController *)sender
                         choseProgram:(id)program;
@end

@interface GraphFavouritesViewController : UITableViewController

@property (nonatomic, strong) NSArray *programs;  // of CalculatorBrain programs
@property (nonatomic, weak) id<GraphsFavouritesViewControllerDelegate> delegate;

@end
