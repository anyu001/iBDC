//  Created by Nanshanweng on 7/2/07.
//  Copyright 2007 . All rights reserved.

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

#import "Controller.h"
#import "NSString(hsv).h"

#import "ToolbarDelegateCategory.h"

NSString *DLIWindowBgColorKey = @"backgroundColor";
NSString *DLIWindowAlphaKey = @"alpha";

@implementation Controller

+(void)initialize 
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *appDefs = [NSMutableDictionary dictionary];
	
   // NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor greenColor]];
    
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor darkGrayColor]];
	
	[appDefs setObject:colorAsData forKey:DLIWindowBgColorKey];
	[appDefs setObject:[NSNumber numberWithFloat:0.7] forKey:DLIWindowAlphaKey];

	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefs];
	
	NSLog(@"registered defaults:%@", appDefs);
	
}

-(void)awakeFromNib
{

	[self setThePath:  @"College_Grade6.dat"];

	wordsArray = [[NSMutableArray alloc]init] ;
	listsArray = [[NSMutableArray alloc]init] ;
	
	[self setListKeyChain: @"Filename#Group"];
	[self setWordKeyChain: @"Word#Explanation#Phonetics"];
	
	
	[self loadTableDataFromFile:@"grouplist.dat" intoArray:listsArray withKeys:listKeyChain];
	
	[self loadTableDataFromFile:thePath intoArray:wordsArray withKeys:wordKeyChain];

	[self setTimeToWord:4];
	[self setFontSize:30];
	
	[listTableView reloadData];
	[wordTableView reloadData];
	
	
	[quizWindow makeKeyAndOrderFront:self];
	[quizWindow setLevel:NSFloatingWindowLevel];
	
	NSData *colorAsData;
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	colorAsData = [defs objectForKey:DLIWindowBgColorKey];
		[wordDisplay setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
		[playField setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
	
	[self shuffleQuiz];
	[self setupToolbar];
	
#pragma mark .... set contentview of  Quiz Window ...
	
	smallSize = [smallView frame].size;
	largeSize = [largeView frame].size;
	
	[quizWindow setContentSize:largeSize];
	[quizWindow setContentView:largeView];
	
	blankView = [[NSView alloc] init];
	
//	[quizWindow setLevel: NSFloatingWindowLevel];

	
}

-(IBAction)setAlwaysOnTop:(id)sender
{	
	
//	NSLog(@"%d", [sender state]);

	[quizWindow setLevel:[sender state]? NSFloatingWindowLevel : NSNormalWindowLevel];
}


-(void)resizeWindowToSize:(NSSize)newSize
{
	NSRect aFrame;
	
	float newHeight = newSize.height;
	float newWidth = newSize.width;
	
	aFrame = [NSWindow contentRectForFrameRect:[quizWindow frame] styleMask:[quizWindow styleMask]];
	
	aFrame.origin.y += aFrame.size.height;
	aFrame.origin.y -= newHeight;
	aFrame.size.height = newHeight;
	aFrame.size.width = newWidth;
	
	aFrame = [NSWindow frameRectForContentRect:aFrame styleMask:[quizWindow styleMask]];
	
	[quizWindow setFrame:aFrame display:YES animate:YES];
	
}


-(IBAction)goLarge:(id)sender
{
	[quizWindow setContentView:blankView];
	[self resizeWindowToSize:largeSize];
	[quizWindow setContentView:largeView];
	[quizWindow setTitle:NSLocalizedString(@"Quiz", nil)];
	[self startQuiz];
}


-(IBAction)goSmall:(id)sender
{
	[quizWindow setContentView:blankView];
	[self resizeWindowToSize:smallSize];
	[quizWindow setContentView:smallView];
	[quizWindow setTitle:NSLocalizedString(@"Word Fun", nil)];
	[self setNextWordTimer];
	 [progressView setDoubleValue:0.0]; 
	count =0;
}



- (NSString *)thePath {
    return [[thePath retain] autorelease];
}

- (void)setThePath:(NSString *)value {
    if (thePath != value) {
        [thePath release];
        thePath = [value copy];
    }
}




- (void) loadTableDataFromFile:(NSString *) aPath intoArray:(NSMutableArray *)myArray withKeys:(NSString *)keyChain

{
	NSString *path = [[NSBundle mainBundle]pathForResource:aPath ofType:@""];
	NSString *hsv = [NSString stringWithContentsOfFile:path 
											  encoding:NSUTF8StringEncoding
												 error:NULL];
	//		NSLog(@"hsv %@", hsv);
	
	
	[myArray addObjectsFromArray:[hsv arrayFromHSVwithKeys:keyChain]];
	
	//	NSLog(@"awakeFromNib:  %@", wordsArray);
	//	NSLog(@"words array count =%d", [wordsArray count]);
	
	[wordTableView reloadData];
	
}

- (int)numberOfRowsInTableView:(NSTableView *)inTableView
{
	
	if (inTableView == wordTableView)
		
		return [wordsArray count];
	
	
	else {
		//		if (inTableView == listTableView)
		return	[listsArray count];
	}
	
}





- (id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	if ( wordTableView == aTableView) 
	{
		
	    NSParameterAssert(rowIndex >= 0 && rowIndex < [wordsArray count]);
		NSDictionary *dict = [wordsArray objectAtIndex:rowIndex];
		//	NSLog(@"%@" , [dict objectForKey: [aTableColumn identifier]]);
		
		return [dict objectForKey: [aTableColumn identifier]]; 
		
	} else {
		//	if ( listTableView == aTableView) 
		NSParameterAssert(rowIndex >= 0 && rowIndex < [listsArray count]);
		NSDictionary *listDict = [listsArray objectAtIndex:rowIndex];
        if ([[aTableColumn identifier] isEqualToString:@"Filename"]) {
            return @"";
        }
		return [listDict objectForKey:[aTableColumn identifier]];
		
	}
}



- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	// Handle: Word 
	if ([[notification object] isEqual:wordTableView]) {
//		[self handleWordTableClick:wordTableView];
//		NSLog(@"word table view selection change");
	}
	// Handle: List
	else 
		if ([[notification object] isEqual:listTableView]) {
		[self handleListTableClick];
	}

}

-(void)handleListTableClick
{
	//	NSLog(@"list table clicked");
	//	NSLog(@"%d", [listTableView selectedRow]);
	NSString *aPath = [NSString stringWithString: [[listsArray objectAtIndex:[listTableView selectedRow]] objectForKey:@"Filename"]];
	//	NSLog(@"%@",aPath);
	
	
	[self setThePath:aPath];
	[self clearWordsArray];
	wordsArray = [[NSMutableArray alloc]init] ;
	[self loadTableDataFromFile:thePath intoArray:wordsArray withKeys:wordKeyChain];
	[wordTableView reloadData];
}



-(void)clearWordsArray
{
	int i;
	
	for (i=0; i< [self countOfWordsArray]; i++)
	{
		[self removeObjectFromWordsArrayAtIndex:i];
	}
	
}



//- (NSArray *)wordsArray {
//    if (!wordsArray) {
//        wordsArray = [[NSMutableArray alloc] init];
//    }
//    return [[wordsArray retain] autorelease];
//}
//

- (unsigned)countOfWordsArray {
    if (!wordsArray) {
        wordsArray = [[NSMutableArray alloc] init];
    }
    return [wordsArray count];
}
//
//- (id)objectInWordsArrayAtIndex:(unsigned)theIndex {
//    if (!wordsArray) {
//        wordsArray = [[NSMutableArray alloc] init];
//    }
//    return [wordsArray objectAtIndex:theIndex];
//}
//
//- (void)getWordsArray:(id *)objsPtr range:(NSRange)range {
//    if (!wordsArray) {
//        wordsArray = [[NSMutableArray alloc] init];
//    }
//    [wordsArray getObjects:objsPtr range:range];
//}
//
//- (void)insertObject:(id)obj inWordsArrayAtIndex:(unsigned)theIndex {
//    if (!wordsArray) {
//        wordsArray = [[NSMutableArray alloc] init];
//    }
//    [wordsArray insertObject:obj atIndex:theIndex];
//}
//


- (void)removeObjectFromWordsArrayAtIndex:(unsigned)theIndex {
    if (!wordsArray) {
        wordsArray = [[NSMutableArray alloc] init];
    }
    [wordsArray removeObjectAtIndex:theIndex];
}


//- (void)replaceObjectInWordsArrayAtIndex:(unsigned)theIndex withObject:(id)obj {
//    if (!wordsArray) {
//        wordsArray = [[NSMutableArray alloc] init];
//    }
//    [wordsArray replaceObjectAtIndex:theIndex withObject:obj];
//}
//
//
//- (NSArray *)listsArray {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    return [[listsArray retain] autorelease];
//}
//
//- (unsigned)countOfListsArray {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    return [listsArray count];
//}
//
//- (id)objectInListsArrayAtIndex:(unsigned)theIndex {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    return [listsArray objectAtIndex:theIndex];
//}
//
//- (void)getListsArray:(id *)objsPtr range:(NSRange)range {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    [listsArray getObjects:objsPtr range:range];
//}
//
//- (void)insertObject:(id)obj inListsArrayAtIndex:(unsigned)theIndex {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    [listsArray insertObject:obj atIndex:theIndex];
//}
//
//- (void)removeObjectFromListsArrayAtIndex:(unsigned)theIndex {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    [listsArray removeObjectAtIndex:theIndex];
//}
//
//- (void)replaceObjectInListsArrayAtIndex:(unsigned)theIndex withObject:(id)obj {
//    if (!listsArray) {
//        listsArray = [[NSMutableArray alloc] init];
//    }
//    [listsArray replaceObjectAtIndex:theIndex withObject:obj];
//}


- (NSString *)listKeyChain {
    return [[listKeyChain retain] autorelease];
}

- (void)setListKeyChain:(NSString *)value {
    if (listKeyChain != value) {
        [listKeyChain release];
        listKeyChain = [value copy];
    }
}

- (NSString *)wordKeyChain {
    return [[wordKeyChain retain] autorelease];
}

- (void)setWordKeyChain:(NSString *)value {
    if (wordKeyChain != value) {
        [wordKeyChain release];
        wordKeyChain = [value copy];
    }
}


#pragma mark .... Toolbar Actions .... 

- ( IBAction ) toggleListDrawer: ( id ) sender
{
	[ listDrawer toggle: self ];
}


-(void)startQuiz
{
	NSLog(@"start quiz...");
	[quizWindow makeKeyAndOrderFront:self];

	[self shuffleQuiz];
	[self stopTimer];
	
}


-(void)shuffleQuiz
{
	NSMutableArray *showArray = [NSMutableArray arrayWithArray:[self randomArrayForQuiz]];
	
	[buttonOne setTitle:[[showArray objectAtIndex:0] objectForKey:@"Explanation"]];
	[buttonTwo  setTitle:[[showArray objectAtIndex:1] objectForKey:@"Explanation"]];
	[buttonThree setTitle:[[showArray objectAtIndex:2] objectForKey:@"Explanation"]];
	[buttonFour setTitle:[[showArray objectAtIndex:3] objectForKey:@"Explanation"]];
	
	[buttonOne setImagePosition:NSImageRight];
	[buttonOne setImage:nil];
	[buttonOne setTarget:self];
	[buttonOne setAction:@selector(wrongAnswer:)];
	
	[buttonTwo setImagePosition:NSImageRight];
	[buttonTwo setImage:nil];
	[buttonTwo setTarget:self];
	[buttonTwo setAction:@selector(wrongAnswer:)];
	
	[buttonThree setImagePosition:NSImageRight];
	[buttonThree setImage:nil];
	[buttonThree setTarget:self];
	[buttonThree setAction:@selector(wrongAnswer:)];
	
	[buttonFour setImagePosition:NSImageRight];
	[buttonFour setImage:nil];
	[buttonFour setTarget:self];
	[buttonFour setAction:@selector(wrongAnswer:)];
	
	
	int j = random() % 4;
	

	
	[self setTheWord: [NSMutableString stringWithString:[[showArray objectAtIndex:4] objectForKey:@"Word"]]];
	[self setTheAnswer: [NSMutableString stringWithString:[[showArray objectAtIndex:4] objectForKey:@"Explanation"]]];
		
	[self displayWord: YES andAnswer:NO];
	
	
	switch(j)
	{
		case 0:
			
			[buttonOne setTitle:[[showArray objectAtIndex:4] objectForKey:@"Explanation"]];
			[buttonOne setTarget:self];
			[buttonOne setAction:@selector(correctAnswer:)];
			break;
			
			
			
		case 1:
			[buttonTwo setTitle:[[showArray objectAtIndex:4] objectForKey:@"Explanation"]];
			[buttonTwo setTarget:self];
			[buttonTwo setAction:@selector(correctAnswer:)];
			break;
			
		case 2:
			
			[buttonThree setTitle:[[showArray objectAtIndex:4] objectForKey:@"Explanation"]];
			[buttonThree setTarget:self];
			[buttonThree setAction:@selector(correctAnswer:)];
			break;
			
		case 3:
			[buttonFour setTitle:[[showArray objectAtIndex:4] objectForKey:@"Explanation"]];
			[buttonFour setTarget:self];
			[buttonFour setAction:@selector(correctAnswer:)];
			break;
	}
	
	
}


-(void)correctAnswer:(id)sender
{
	
//	NSLog(@"correct answer action");
	
	[sender setImagePosition:NSImageRight];
	[sender setImage:[NSImage imageNamed:@"cool.tiff"]];
	
	[self displayWord: YES andAnswer:YES];
	
									
	[self performSelector:@selector(shuffleQuiz)
			   withObject:nil
			   afterDelay:3.0];
}	



-(void)displayWord:(BOOL)wordFlag andAnswer: (BOOL)answerFlag
{
	[wordDisplay setFont: [NSFont systemFontOfSize: [self fontSize]]];
	
	[wordDisplay setStringValue:[self theWord]];
	
	if (answerFlag  && wordFlag) {
		[wordDisplay setStringValue: [[[self theWord] stringByAppendingString:@"\n\n"] stringByAppendingString:[self theAnswer]]];
	}	
}


-(void)startPlay

    
{
    [self stopTimer];
    [self autoPlay];
    [self setNextWordTimer];
}

-(void)autoPlay
{
	[self shuffleQuiz];
	[self displayWord:YES andAnswer:YES];
	[playField setFont: [NSFont systemFontOfSize: [self fontSize]]];
	[playField setStringValue: [[[self theWord] stringByAppendingString:@"\n\n"] stringByAppendingString:[self theAnswer]]];
	count++;
	[progressView needsDisplay];
	[progressView setDoubleValue:( 100.0 * count ) / [self timeToWord]];

	
}

-(void)wrongAnswer:(id)sender
{
//	NSLog(@"wrong acnser action ....");
	[sender setImagePosition:NSImageRight];
	[sender setImage:[NSImage imageNamed:@"wrong.tiff"]];
	
}

#pragma mark .... timer stuff ...

-(void)setNextWordTimer
{
	NSLog(@"timeToWord = %d", [self timeToWord]);
		  
	if (!timerWord)
	{
		timerWord  = [[NSTimer scheduledTimerWithTimeInterval:[self timeToWord]
											  target:self
												 selector:@selector(autoPlay)
											userInfo:NULL
											 repeats:YES] retain];
	}
	
	[timerWord fire];
}



-(void)stopTimer
{
	if (timerWord) {
		[timerWord invalidate];
		timerWord = nil;
		
	}
}


#pragma mark ... answer/word .....

- (NSString *)theWord {
    return [[theWord retain] autorelease];
}

- (void)setTheWord:(NSString *)value {
    if (theWord != value) {
        [theWord release];
        theWord = [value copy];
    }
}

- (NSString *)theAnswer {
    return [[theAnswer retain] autorelease];
}

- (void)setTheAnswer:(NSString *)value {
    if (theAnswer != value) {
        [theAnswer release];
        theAnswer = [value copy];
    }
}

#pragma mark .... play ......

-(IBAction)startPlay:(id)sender
{
	NSLog(@"start Play ....");
	[quizWindow makeKeyAndOrderFront:self];
	[self shuffleQuiz];
	
	[self setNextWordTimer];
	
}



-(NSArray *)randomArrayForQuiz
{
	int index;

	NSMutableArray *randomArray = [[NSMutableArray alloc]init];
		
	srandom(time(NULL));
	while ( [randomArray count] <  6 )
	{
		
		index = random() % [wordsArray count];
		[randomArray addObject:[wordsArray objectAtIndex:index]];
	}
	
	return [randomArray autorelease];
}
	

#pragma mark .... Pref Panel methods ....

- (NSColor *)backgroundColor {
	NSUserDefaults *defaults;
	NSData *colorAsData;
	
	defaults = [NSUserDefaults standardUserDefaults];
	colorAsData = [defaults objectForKey:DLIWindowBgColorKey];
    NSError * error;
    [NSKeyedUnarchiver unarchivedObjectOfClass:NSColor.class fromData:colorAsData error:&error];

	//return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
	
//    return [[backgroundColor retain] autorelease];
}

- (void)setBackgroundColor:(NSColor *)value {
    if (backgroundColor != value) {
        [backgroundColor release];
        backgroundColor = [value copy];
    }
}

- (NSString *)fontName {
    return [[fontName retain] autorelease];
}

- (void)setFontName:(NSString *)value {
    if (fontName != value) {
        [fontName release];
        fontName = [value copy];
    }
}

- (int)fontSize {
    return fontSize;
}

- (void)setFontSize:(int)value {
    if (fontSize != value) {
        fontSize = value;
    }
}


- (int)timeToWord {
    return timeToWord;
}

- (void)setTimeToWord:(int)value {
    if (timeToWord != value) {
        timeToWord = value;
    }
}



#pragma mark ... Pref Panel IB ....
- (IBAction)changeTimeToWord:(id)sender
{
	[self setTimeToWord:[sender intValue]];
	[timerField setIntValue:[sender intValue]];
	[self setNextWordTimer];
}



- (IBAction)changeTransparency:(id)sender
{
	NSLog(@"alpha = %f", [sender floatValue]);
	[quizWindow setAlphaValue:[sender floatValue]];
	
}


- (IBAction)changeBackgroundColor:(id)sender
{
	NSColor *color = [sender color];
	NSData *colorAsData;
	colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
	NSUserDefaults *defaults;
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:colorAsData forKey:DLIWindowBgColorKey];
	[wordDisplay setBackgroundColor:[backgroundColorWell color]];
	[playField setBackgroundColor:[backgroundColorWell color]];
}


-(IBAction)showPrefPanel:(id)sender
{
	[prefPanel makeKeyAndOrderFront:sender];
}



-(void)dealloc
{
	[wordsArray release];
	[listsArray release];
	[timerWord release];
	
	[super dealloc];
}


@end
