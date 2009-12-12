//
//  CustomButtonCell.h
//  MatrixSample
//
//  Created by 湖 on 09/12/08.
//  Copyright 2009 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
enum {
	CELL_STATE_OFF,
	CELL_STATE_ON,
	CELL_STATE_OVER
};

@interface ApplicationButtonCell : NSCell {

	NSImage* image;
	NSString* name;
	NSUInteger cellState;
}
@property (retain) NSImage* image;
@property (retain) NSString* name;
@property (assign) NSUInteger cellState;

-(id)initWithPath:(NSString*)appPath;
+(ApplicationButtonCell*)cellWithPath:(NSString*)appPath;
@end
