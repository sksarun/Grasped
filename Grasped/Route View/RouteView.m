//
//  RouteView.m
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 2/2/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouteView.h"


@implementation RouteView
@synthesize mapView,decodeList;

-(id) initWithGeoList:(NSMutableArray*)list mapView:(MKMapView*)map
{
	self = [super initWithFrame:CGRectMake(0, 0, 900,900)];
	self.mapView = map;
	self.decodeList = list;
	self.userInteractionEnabled = NO;
	[self setBackgroundColor:[UIColor clearColor]];
	[self setNeedsDisplay];
	return self;
}

- (void)drawRect:(CGRect)rect
{
	// only draw our lines if we're not int he moddie of a transition and we
	// acutally have some points to draw.
	if(!self.hidden && nil != self.decodeList && self.decodeList.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 3.0);
		
		for(int idx = 0; idx < [self.decodeList count]; idx++)
		{
			CLLocation* location = [self.decodeList objectAtIndex:idx];
			CGPoint point = [self.mapView convertCoordinate:location.coordinate toPointToView:self];
			
			if(idx == 0)
			{
				// move to the first point
				CGContextMoveToPoint(context, point.x, point.y);
			}
			else
			{
				CGContextAddLineToPoint(context, point.x, point.y);
			}
		}
		
		CGContextStrokePath(context);
	}
	
}


- (void)dealloc {
	[self.mapView release];
	[self.decodeList release];
    [super dealloc];
}


@end
