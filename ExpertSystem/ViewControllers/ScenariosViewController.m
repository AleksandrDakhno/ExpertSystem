//
//  ScenariosViewController.m
//  ExpertSystem
//
//  Created by Aleksandr Dakhno on 28/08/14.
//  Copyright (c) 2014 DAV. All rights reserved.
//

#import "ScenariosViewController.h"
#import "DataManager.h"
#import "Scenario.h"
#import "CaseViewController.h"

@interface ScenariosViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ScenariosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self requestScenariosList];
}

#pragma mark - Methods
- (void)requestScenariosList {
    [self.activityIndicator startAnimating];
    [[DataManager instance] requestScenariousListWithCompletion:^(NSArray *scenariosList, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            NSLog(@"error getting scenarious list: %@", error.localizedDescription);
        } else {
            NSLog(@"scenarios list: %@", scenariosList);
            self.scenariosList = scenariosList;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scenariosList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    Scenario *scenario = self.scenariosList[indexPath.row];
    cell.textLabel.text = scenario.text;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Scenario *scenario = self.scenariosList[indexPath.row];
    CaseViewController *caseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseViewController"];
    caseViewController.caseId = scenario.caseId;
    [self presentViewController:caseViewController animated:YES completion:^{
        [self.tableView reloadData];
    }];
}

@end
