//
//  GraphView.h
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;

@protocol GraphVewDataSource <NSObject>

-(double) valueOfYForValueX:(double) x inGraphView:(GraphView *) sender;
-(void) storeScale:(CGFloat) scale inGraphView:(GraphView *) sender;
-(void) storeOrigin:(CGPoint) origin inGraphView:(GraphView *) sender;

@end



@interface GraphView : UIView

@property (nonatomic) CGPoint myGraphOrigin;
@property (nonatomic) CGFloat myGraphScale;
@property (nonatomic, weak) IBOutlet id <GraphVewDataSource> dataSource;

-(void)taps:(UITapGestureRecognizer *) gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)pan:(UIPanGestureRecognizer *)gesture;
@end
