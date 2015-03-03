//
// Created by Aleksandr Dakhno on 28/08/14.
// Copyright (c) 2014 DAV. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseData.h"
#import "DataManager.h"
#import "CaseCell.h"
#import "ScenariosViewController.h"

@interface CaseViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CaseData *caseData;
@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCaseData];
}

#pragma mark - Methods
- (void)loadCaseData {
    [self.activityIndicator startAnimating];
    [[DataManager instance] requestCaseWithId:self.caseId completion:^(CaseData *caseData, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            NSLog(@"error getting case with id - %@: %@", self.caseId, error);
        } else {
            NSLog(@"loaded case data");
            self.caseData = caseData;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.caseData ? (self.caseData.answers.count ? 3 : 2) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell" forIndexPath:indexPath];
    cell.dataImageView.hidden = YES;
    cell.dataLabel.hidden = NO;

    switch (indexPath.row) {
        case 0: {
            cell.dataImageView.hidden = YES;
            cell.dataLabel.hidden = NO;

            cell.titleLabel.text = @"Text";
            cell.dataLabel.text = self.caseData.text;
            break;
        }
        case 1: {
            cell.dataImageView.hidden = NO;
            cell.dataLabel.hidden = YES;

            cell.titleLabel.text = @"Image";
            [[DataManager instance] loadImageForURL:self.caseData.imageURL withCompletion:^(UIImage *image, NSError *error) {
                if (error) {
                    NSLog(@"error loading image: %@", error.localizedDescription);
                } else {
                    cell.dataImageView.image = image;
                }
            }];
            break;
        }
        case 2: {
            cell.dataImageView.hidden = YES;
            cell.titleLabel.hidden = YES;
            cell.dataLabel.hidden = NO;

            cell.dataLabel.text = @"PRESS FOR ANSWER";
            break;
        }
        default: break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 2) {
        ScenariosViewController *scenariosViewController = (ScenariosViewController *) self.presentingViewController;
        scenariosViewController.scenariosList = self.caseData.answers;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end