//
//  ToolbarDelegateCategory.m
//  iBDC
//
//  Created by Nanshanweng on 7/2/07.
//  Copyright 2007  All rights reserved.
//
/* This program is free software; you can redistribute it and/or modify it under the terms of the GNU
* General Public License as published by the Free Software Foundation; either version 2 of the License,
* or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
* the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
* Public License for more details.
* 
* You should have received a copy of the GNU General Public License along with this program; if not,
* write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#import "ToolbarDelegateCategory.h"


@implementation Controller (ToolbarDelegateCategory)


-(NSToolbarItem *)toolbar:(NSToolbar *)toolbar 
	itemForItemIdentifier:(NSString *)itemIdentifier
willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier: itemIdentifier];
	
	if ( [itemIdentifier isEqualToString:@"GroupItem"] ) 
	{
		[item setLabel:NSLocalizedString(@"List",nil)];
		[item setPaletteLabel:[item label]];
		[item setImage: [NSImage imageNamed:@"DrawerToggleToolbarImage.tiff"]];
		[item setTarget:self];
		[item setAction:@selector(toggleListDrawer:)];
		
	} else if ( [itemIdentifier isEqualToString:@"QuizItem"] )
	{

		[ item setLabel: NSLocalizedString( @"Quiz", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ NSImage imageNamed: @"stb_info.tiff" ] ];
		[ item setTarget: self ];
		[ item setAction: @selector( goLarge: ) ];
		
	} else if ( [itemIdentifier isEqualToString:@"PlayItem"] )
	{
		[ item setLabel: NSLocalizedString( @"Play", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ NSImage imageNamed: @"Prefs_Camera.tiff" ] ];
		[ item setTarget: self ];
		[ item setAction: @selector( goSmall: ) ];
		
		
	}else if ( [itemIdentifier isEqualToString:@"PrefItem"] )
	{
		[ item setLabel: NSLocalizedString( @"Preference", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ NSImage imageNamed: @"Prefs_General.tiff" ] ];
		[ item setTarget: self ];
		[ item setAction: @selector( showPrefPanel: ) ];
		
		
	}
	
		
		
	return [item autorelease];
	
}

-(NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
		NSToolbarSeparatorItemIdentifier,
		NSToolbarSpaceItemIdentifier,
		NSToolbarFlexibleSpaceItemIdentifier,
		NSToolbarCustomizeToolbarItemIdentifier,
		@"PrefItem",
		@"PlayItem",
		@"QuizItem",
		@"GroupItem",
		nil];
}


-(NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
		@"PrefItem",
		//NSToolbarCustomizeToolbarItemIdentifier,
		//NSToolbarFlexibleSpaceItemIdentifier,
		@"PlayItem",
		@"QuizItem",
		@"GroupItem",
	
		nil];
}


-(void)setupToolbar
{
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"myCoolToolbar"];
//	[toolbar autorelease];
	[toolbar setDelegate:self];
	[toolbar setAllowsUserCustomization:YES];
	[toolbar setAutosavesConfiguration:YES];
	[mainWindow setToolbar:[toolbar autorelease]];
	
		
	
}
@end
