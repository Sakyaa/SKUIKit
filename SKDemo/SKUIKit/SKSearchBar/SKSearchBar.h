//
//  SKSearchBar.h
//  UnionProgarm
//
//  Created by Sakya on 17/3/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SKSearchBar;
@protocol SKSearchBarDelegate <UIBarPositioningDelegate>

@optional
-(BOOL)sk_searchBarShouldBeginEditing:(SKSearchBar *)searchBar;                      // return NO to not become first responder
- (void)sk_searchBarTextDidBeginEditing:(SKSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)sk_searchBarShouldEndEditing:(SKSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)sk_searchBarTextDidEndEditing:(SKSearchBar *)searchBar;                       // called when text ends editing
- (void)sk_searchBar:(SKSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)sk_searchBar:(SKSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)sk_searchBarSearchButtonClicked:(SKSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)sk_searchBarCancelButtonClicked:(SKSearchBar *)searchBar;                     // called when cancel button pressed
// called when cancel button pressed
@end

@interface SKSearchBar : UIView<UITextInputTraits>

@property(nullable,nonatomic,weak) id<SKSearchBarDelegate> delegate; // default is nil. weak reference
@property(nullable,nonatomic,copy) NSString  *text;                  // current/starting search text
@property(nullable,nonatomic,copy) NSString  *placeholder;           // default is nil. string is drawn 70% gray
@property(nonatomic) BOOL  showsCancelButton;                        // default is yes
@property(nullable,nonatomic,strong) UIColor *textColor;             // default is nil. use opaque black
@property(nullable,nonatomic,strong) UIFont  *font;                  // default is nil. use system font 12 pt
@property(nullable,nonatomic,strong) UIColor *placeholderColor;      // default is drawn 70% gray
//外部区别是否显示按钮
@property(nullable,nonatomic,assign) BOOL *hideCancelButton;      // default is hide

/* Allow placement of an input accessory view to the keyboard for the search bar
 */
@property (nullable,nonatomic,readwrite,strong) UIView *inputAccessoryView;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
@end

NS_ASSUME_NONNULL_END
