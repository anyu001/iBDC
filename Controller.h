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


/* Controller */

#import <Cocoa/Cocoa.h>

extern NSString *DLIWindowBgColorKey;
extern NSString *DLIWindowAlphaKey;

@interface Controller : NSObject
{
	IBOutlet NSDrawer *listDrawer;
	IBOutlet NSTableView *wordTableView;
	IBOutlet NSTableView *listTableView;
	IBOutlet NSWindow *mainWindow;
	
	IBOutlet NSButton *buttonFour;
    IBOutlet NSButton *buttonOne;
    IBOutlet NSButton *buttonThree;
    IBOutlet NSButton *buttonTwo;
	IBOutlet NSWindow *quizWindow;
	IBOutlet NSTextField *wordDisplay;
	IBOutlet NSProgressIndicator *progressView;

	//pref panel
	IBOutlet NSSlider *timeToWordSlider;

	IBOutlet NSSlider *transparencySlider;
	IBOutlet NSColorWell *backgroundColorWell;
	IBOutlet NSPanel *prefPanel;
	IBOutlet NSButton *alwaysOnTopButton;
	
	//resize window 
	IBOutlet NSView *smallView;
	IBOutlet NSView *largeView;
	IBOutlet NSTextField *playField;
	IBOutlet NSTextField *timerField;
	
	NSSize smallSize, largeSize;
	NSView *blankView;
		
		
	
	NSFontPanel *fontPanel;
	
	NSMutableArray *wordsArray;
	NSMutableArray *listsArray; 
	
	NSString *listKeyChain;
	NSString *wordKeyChain;
	
	NSString *thePath;
	
	NSString *theWord;
	NSString *theAnswer;
	
	NSTimer *timerWord;

	
	NSColor *textColor;
	NSColor	*backgroundColor;
	NSString *fontName;
	int fontSize;
	
	int timeToWord;
	int timeToAnswer;
	
	int count;
	int alpha;
	
}


- (void) loadTableDataFromFile:(NSString *) aPath intoArray:(NSMutableArray*)aArray withKeys:(NSString *)keyChain;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;


//toolbar actions
-(IBAction)toggleListDrawer:(id)sender;
-(void)startQuiz;
-(IBAction)startPlay:(id)sender;
-(void)shuffleQuiz;
-(NSArray *)randomArrayForQuiz;

-(void)handleListTableClick;
-(void)tableViewSelectionDidChange:(NSNotification *)aNotification;
-(void) clearWordsArray;
- (NSString *)thePath;
- (void)setThePath:(NSString *)value;


- (NSArray *)wordsArray;
- (unsigned)countOfWordsArray;
- (id)objectInWordsArrayAtIndex:(unsigned)theIndex;
- (void)getWordsArray:(id *)objsPtr range:(NSRange)range;
- (void)insertObject:(id)obj inWordsArrayAtIndex:(unsigned)theIndex;
- (void)removeObjectFromWordsArrayAtIndex:(unsigned)theIndex;
- (void)replaceObjectInWordsArrayAtIndex:(unsigned)theIndex withObject:(id)obj;

- (NSArray *)listsArray;
- (unsigned)countOfListsArray;
- (id)objectInListsArrayAtIndex:(unsigned)theIndex;
- (void)getListsArray:(id *)objsPtr range:(NSRange)range;
- (void)insertObject:(id)obj inListsArrayAtIndex:(unsigned)theIndex;
- (void)removeObjectFromListsArrayAtIndex:(unsigned)theIndex;
- (void)replaceObjectInListsArrayAtIndex:(unsigned)theIndex withObject:(id)obj;

- (NSString *)listKeyChain;
- (void)setListKeyChain:(NSString *)value;

- (NSString *)wordKeyChain;
- (void)setWordKeyChain:(NSString *)value;


#pragma mark .....answer/word ....
- (NSString *)theWord;
- (void)setTheWord:(NSString *)value;

- (NSString *)theAnswer;
- (void)setTheAnswer:(NSString *)value;

-(void)displayWord:(BOOL)wordFlag andAnswer: (BOOL)answerFlag;


#pragma mark  ........ Pref Panel ......
- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)value;


- (int)fontSize;
- (void)setFontSize:(int)value;


- (int)timeToWord;
- (void)setTimeToWord:(int)value;




#pragma mark  ........ Pref Panel (IBOutlets) ......


- (IBAction)changeTimeToWord:(id)sender;

- (IBAction)changeTransparency:(id)sender;

- (IBAction)changeBackgroundColor:(id)sender;


-(IBAction)showPrefPanel:(id)sender;

-(IBAction)setAlwaysOnTop:(id)sender;


#pragma mark .... resize Quiz Widnow ...

-(IBAction)goSmall:(id)sender;
-(IBAction)goLarge:(id)sender;


@end
