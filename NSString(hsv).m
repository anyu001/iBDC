//  Created by Nanshanweng on 6/30/07.
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

#import "NSString(hsv).h"


@implementation NSString (hsv)

-(NSArray *)componentsSeparatedByLineSeparators
{
	NSScanner		*scanner = [NSScanner scannerWithString:self];
	NSCharacterSet *newLineSet=[NSCharacterSet characterSetWithCharactersInString:@"\n"];
	NSMutableArray *lineArray = [NSMutableArray array];
	NSString *trimmedString;
	while ([scanner isAtEnd] == NO) {
		[scanner scanUpToCharactersFromSet:newLineSet intoString:&trimmedString];
		[lineArray addObject:trimmedString];
	}
	
	//[scanner release];
	return lineArray;
	
	

	
}

//
//-(NSArray *)setKeys
//{
//	NSArray *keys = [NSArray arrayWithObjects:@"Word",@"Explanation",@"Phonetics",nil];
//	
//	return keys;
//	
//}
	
-(NSArray *)arrayFromHSVwithKeys:(NSString*) keyChain
{
	NSMutableArray *myWords = [NSMutableArray array];
	NSArray *lines = [self componentsSeparatedByLineSeparators];
	NSEnumerator *e = [lines objectEnumerator];
	NSArray *keys = [NSArray array];
	keys = nil;
	
//	NSString *keyLine = [keyChain copy];
	
	
	int keyCount=0;
	NSString *theLine;
	
	while (nil !=(theLine = [e nextObject]) )
	{
		if (![theLine isEqual:@""] )
		{
			if (nil == keys)
			{
				
				
				keys = [keyChain componentsSeparatedByString:@"#"];
				keyCount = [keys count];
		//		NSLog(@"KeyCount= %d", keyCount);
			} else 
			{
				NSMutableDictionary *lineDict = [NSMutableDictionary dictionary];
				NSArray *values = [theLine componentsSeparatedByString:@"#"];
			
				int  valueCount = [values count];
			//	NSLog(@"values count = %d", valueCount);
			//	NSLog(@"---------------------------------");
				int i;
				
				for (i =0; i< keyCount && i< valueCount ; i++)
				{
					
					NSString *value = [values objectAtIndex:i];
					if (nil !=value && ![value isEqualTo:@""]) 
					{
					//	NSLog(@"%@", value);
						[lineDict setObject:value forKey:[keys objectAtIndex:i]];
					//	NSLog(@"%@:\t%@", [keys objectAtIndex:i],value );

					}
				}
				
				if ( [lineDict count] )
				{
					[myWords addObject:lineDict];
				}
			}
		} 
		//[keyChain release];
	}
	
	return myWords;
}
@end
