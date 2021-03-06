#import "MoreController.h"
#import "OrganizationsController.h"
#import "IssuesController.h"
#import "AccountController.h"
#import "GHUser.h"
#import "GHRepository.h"
#import "iOctocat.h"


@implementation MoreController

@synthesize user;
@synthesize moreOptions;

+ (id)controllerWithUser:(GHUser *)theUser {
	return [[[MoreController alloc] initWithUser:theUser] autorelease];
}

- (id)initWithUser:(GHUser *)theUser {
	[super initWithNibName:@"More" bundle:nil];
	
	// Organizations
	NSArray *orgsVals = [NSArray arrayWithObjects:@"Organizations", @"MoreOrgs.png", nil];
	NSArray *orgsKeys = [NSArray arrayWithObjects:@"label", @"image", nil];
	NSDictionary *orgsDict = [NSDictionary dictionaryWithObjects:orgsVals forKeys:orgsKeys];
	
	// My Issues
	NSArray *myIssuesVals = [NSArray arrayWithObjects:@"My Issues", @"MoreIssues.png", nil];
	NSArray *myIssuesKeys = [NSArray arrayWithObjects:@"label", @"image", nil];
	NSDictionary *myIssuesDict = [NSDictionary dictionaryWithObjects:myIssuesVals forKeys:myIssuesKeys];
	
	// iOctocat Issues
	NSArray *appIssuesVals = [NSArray arrayWithObjects:@"iOctocat Feedback", @"MoreApp.png", nil];
	NSArray *appIssuesKeys = [NSArray arrayWithObjects:@"label", @"image", nil];
	NSDictionary *appIssuesDict = [NSDictionary dictionaryWithObjects:appIssuesVals forKeys:appIssuesKeys];
	
	self.moreOptions = [NSArray arrayWithObjects:orgsDict, myIssuesDict, appIssuesDict, nil];
	self.user = theUser;
	
	return self;
}

- (AccountController *)accountController {
	return [[iOctocat sharedInstance] accountController];
}

- (UIViewController *)parentViewController {
	return [[[[iOctocat sharedInstance] navController] topViewController] isEqual:self.accountController] ? self.accountController : nil;
}

- (UINavigationItem *)navItem {
	return [[[[iOctocat sharedInstance] navController] topViewController] isEqual:self.accountController] ? self.accountController.navigationItem : self.navigationItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navItem.title = @"More";
	self.navItem.titleView = nil;
	self.navItem.rightBarButtonItem = nil;
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [moreOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSUInteger row = indexPath.row;
	NSDictionary *dict = [moreOptions objectAtIndex:row];
	cell.textLabel.text = [dict valueForKey:@"label"];
	cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"image"]];
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	UIViewController *viewController = nil;
	if (row == 0) {
		viewController = [OrganizationsController controllerWithOrganizations:user.organizations];
	} else if (row == 1) {
		viewController = [IssuesController controllerWithUser:user];
	} else if (row == 2) {
		GHRepository *repo = [GHRepository repositoryWithOwner:@"dennisreimann" andName:@"iOctocat"];
		viewController = [IssuesController controllerWithRepository:repo];
	}
	// Maybe push a controller
	if (viewController) {
		UINavigationController *navController = [[iOctocat sharedInstance] navController];
		[navController pushViewController:viewController animated:YES];
	}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
	[moreOptions release], moreOptions = nil;
    [super dealloc];
}


@end

