/*
 * Copyright (c) 13/11/2012 Mario Negro (@emenegro)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

@class MNMPullToRefreshView;
@class MNMPullToRefreshManager;

/**
 * Delegate protocol to implement by `MNMPullToRefreshManager` observers to keep track of changes in pull-to-refresh view
 * and its state.
 */
@protocol MNMPullToRefreshManagerClient

/**
 * This is the same delegate method of `UIScrollViewDelegate` but required in `MNMPullToRefreshManagerClient` protocol
 * to warn about its implementation.
 *
 * In the implementation of this method you have to call `[MNMPullToRefreshManager tableViewScrolled]`
 * to indicate that the table is being scrolled.
 *
 * @param scrollView The scroll-view object in which the scrolling occurred.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 * This is the same delegate method of `UIScrollViewDelegate` but required in `MNMPullToRefreshClient` protocol
 * to warn about its implementation.
 *
 * In the implementation of this method you have to call `[MNMPullToRefreshManager tableViewReleased]`
 * to indicate that the table scroll stops and the dragging has ended.
 *
 * @param scrollView The scroll-view object that finished scrolling the content view.
 * @param decelerate YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 * Tells client that refreshing has been triggered.
 *
 * After reload is completed don't miss call `[MNMPullToRefreshManager tableViewReloadFinishedAnimated:]` to indicate that the 
 * view has to get back to the Idle initial state.
 *
 * @param manager The pull to refresh manager.
 */
- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager;

@end

/**
 * Manager that plays Mediator role and manages relationship between a pull-to-refresh view and its associated table.
 */
@interface MNMPullToRefreshManager : NSObject

/**
 * Initializes the manager object with the information to link view and table.
 *
 * @param height The height that the pull-to-refresh view will have. This will be the `fixedHeight` used to trigger the refreshing.
 * @param table Table view to link pull-to-refresh view to.
 * @param client The client that will observe chnages in the view.
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id<MNMPullToRefreshManagerClient>)client;

/**
 * Sets the pull-to-refresh view visible or not. Visible by default.
 *
 * @param visible YES to make it visible.
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible;

/**
 * Checks the state of the pull to refresh view depending on the table's offset
 */
- (void)tableViewScrolled;

/**
 * Checks releasing of the table to trigger refreshing.
 */
- (void)tableViewReleased;

/**
 * Indicates that the reload of the table is completed.
 *
 * @param animated YES to animate the transition from Loading state to Idle state.
 */
- (void)tableViewReloadFinishedAnimated:(BOOL)animated;

@end
