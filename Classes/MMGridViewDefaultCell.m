//
// Copyright (c) 2010-2011 René Sprotte, Provideal GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#define K_DEFAULT_LABEL_HEIGHT  30
#define K_DEFAULT_LABEL_INSET   5

#import "MMGridViewDefaultCell.h"

@implementation MMGridViewDefaultCell



@synthesize backgroundView;

- (void)dealloc
{
 
    [backgroundView release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Background view
        self.backgroundView = [[[UIImageView alloc] initWithFrame:CGRectNull] autorelease];
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.backgroundView];

        

    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    labelHeight = K_DEFAULT_LABEL_HEIGHT;
    labelInset = K_DEFAULT_LABEL_INSET;
    
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
  
}

@end
