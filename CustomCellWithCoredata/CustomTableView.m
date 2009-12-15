//
//  CustomTableView.m
//  CustomCellWithCoredata
//
//  Created by 橋口 湖 on 09/12/11.
//  Copyright 2009 xcatsan.com. All rights reserved.
//

#import "CustomTableView.h"

#import "CustomCell.h"

@implementation CustomTableView
@synthesize trackingArea, cell;
#pragma mark -
#pragma mark Tracking Utility
- (void)updateTrackingArea
{
	if (self.trackingArea) {
		[self removeTrackingArea:self.trackingArea];
	}
	self.trackingArea = [[[NSTrackingArea alloc]
						  initWithRect:[self frame]
						  options:(NSTrackingMouseEnteredAndExited |
								   NSTrackingMouseMoved |
								   NSTrackingActiveAlways )
						  owner:self
						  userInfo:nil] autorelease];
	[self addTrackingArea:self.trackingArea];
}

#pragma mark -
#pragma mark Initialization and Deallocation
- (void)awakeFromNib
{
	[[[self tableColumns] objectAtIndex:0] setDataCell:cell];	
	// #TODO: Must call after data loading (or repeatly ?)
	[self updateTrackingArea];
}

- (void) dealloc
{
	if (self.trackingArea) {
		[self removeTrackingArea:self.trackingArea];
	}
	self.trackingArea = nil;
	[super dealloc];
}



#pragma mark -
#pragma mark Event handler (Overridden)
- (BOOL)isVisible:(NSEvent*)theEvent
{
	NSPoint p = [self convertPointFromBase:[theEvent locationInWindow]];
	return NSPointInRect(p, [self visibleRect]);
}

- (CustomCell*)cellOnMouse:(NSEvent*)theEvent
{
	NSPoint mp = [self convertPointFromBase:[theEvent locationInWindow]];
	NSInteger column = [self columnAtPoint:mp];
	NSInteger row = [self rowAtPoint:mp];
	
	CustomCell* targetCell = (CustomCell*)[self preparedCellAtColumn:column row:row];
	return targetCell;
}

- (void)redrawCell:(NSEvent*)theEvent
{
	NSPoint mp = [self convertPointFromBase:[theEvent locationInWindow]];
	NSInteger column = [self columnAtPoint:mp];
	NSInteger row = [self rowAtPoint:mp];

	if (column != previousColumn || row != previousRow) {
		if (previousColumn >= 0 && previousRow >= 0) {

			[self setNeedsDisplayInRect:
			 [self frameOfCellAtColumn:previousColumn row:previousRow]];
		}
	}
	if (column >= 0 && row >= 0) {
		[self setNeedsDisplayInRect:[self frameOfCellAtColumn:column row:row]];
	}
	previousColumn = column;
	previousRow = row;
}

- (void)mouseDown:(NSEvent*)theEvent
{
	if ([self isVisible:theEvent]) {
		CustomCell* targetCell = [self cellOnMouse:theEvent];
		[targetCell handleMouseDown:theEvent];
		[self redrawCell:theEvent];
	}
	[super mouseDown:theEvent];
}


- (void)mouseUp:(NSEvent*)theEvent
{
	// #TODO: didn't be called
	NSLog(@"UP");
	if ([self isVisible:theEvent]) {
		CustomCell* targetCell = [self cellOnMouse:theEvent];
		[targetCell handleMouseUp:theEvent];
		[self redrawCell:theEvent];
	}
	[super mouseUp:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	if ([self isVisible:theEvent]) {
		CustomCell* targetCell = [self cellOnMouse:theEvent];
		[targetCell handleMouseEntered:theEvent];
		[self redrawCell:theEvent];
	}
	[super mouseEntered:theEvent];
}
- (void)mouseExited:(NSEvent *)theEvent
{
	[cell handleMouseExited:theEvent];
	[super mouseExited:theEvent];
	[self setNeedsDisplay:YES];
}
- (void)mouseMoved:(NSEvent *)theEvent
{
	if ([self isVisible:theEvent]) {
		CustomCell* targetCell = [self cellOnMouse:theEvent];
		[targetCell handleMouseMoved:theEvent];
		[self redrawCell:theEvent];
	}
	[super mouseMoved:theEvent];
}

#pragma mark -
#pragma mark Overidden methods
- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	// do nothing
}

- (void)viewDidEndLiveResize
{
//	NSLog(@"viewDidEndLiveResize %@", NSStringFromRect([self visibleRect]));
	[self updateTrackingArea];
	[super viewDidEndLiveResize];
}
@end