##Client Installation

+ Download and unzip the module
+ Add the folder `TwoFactorAuth` to `ChatSDK`
+ Add the pod to the `Podfile`
```
    pod "TwoFactorAuth", :path => "../TwoFactorAuth"
```
+ Run ```pod install```
+ Set the server path

In `Info.plist`
```
two_factor_auth_server_path: http://[url-to-your-two-factor-auth-server]
```
**Make sure there is no trailing slash.**

For instructions on installing the server see below. 

###Enabling the module
Add this to `AppDelegate.h`

```
#import <TwoFactorAuth/TwoFactorAuth.h>

// Implement the two factor auth delegate delegate
@interface AppDelegate : UIResponder <UIApplicationDelegate, BTwoFactorAuthDelegate> {
    BAppTabBarController * _mainViewController;
    BVerifyViewController * _verifyViewController;
}
```

Add this code to `app: didFinishLaunching`

```ObjC
    _verifyViewController = [[BVerifyViewController alloc] initWithNibName:nil bundle:nil];;
    _verifyViewController.delegate = self;
    adapter.auth.challengeViewController = _verifyViewController;
```

Add the delegate method:

```ObjC
-(void) numberVerifiedWithToken:(NSString *)token {
    [[BNetworkManager sharedManager].a.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeCustom),
                                                                                        bLoginCustomToken: token}].thenOnMain(^id(id<PUser> user) {
        [self authenticationFinishedWithUser:user];
        return Nil;
    }, ^id(NSError * error) {
        [BTwoFactorAuthUtils alertWithError: error.localizedDescription];
        
        // Still need to remove the HUD else we get stuck
        
        [self authenticationFinishedWithUser:nil];
        return Nil;
    });
}

-(void) authenticationFinishedWithUser: (id<PUser>) user {
    if (user) {
        [_verifyViewController dismissViewControllerAnimated:YES completion:^{
            _verifyViewController.phoneNumber.text = @"";
        }];
    }
    [_verifyViewController hideHUD];
}
```

##Server Installation

To run the two factor auth module you need a PHP/Apache/MySQL server. 

Deployment:

1. Upload the server code to your server
2. Navigate to the *root directory* using ssh (this is the directory that contains: app, bin, src etc...)
3. Run 'composer install' in the terminal
4. You should be prompted to enter the details of your SQL database

Or you should edit the parameters file:

`app/config/parameters.yml `

    database_host: 127.0.0.1
    database_port: null
    database_name: database_name
    database_user: database_user
    database_password: database_password
    
You will also be prompted to enter some parameters like the Firebase email and secret and the Twilio phone number. If you have these already you can add them. Otherwise just leave them blank and you will finish configuring the parameters below. When you enter parameters make sure you encase them in speech marks i.e. **"+1201425000"**
    
Now you can run the setup script:

```
sh setup.sh
```

The script will setup the database, permissions and finish the installation. If you would like a description of what the script is actually doing, you can see below. 

####Script Actions
Create the database with the command (this step may be handled by composer):

`php bin/console doctrine:database:create`

Create the tables:

`php bin/console doctrine:schema:update --force`

Sometimes you may get a 500 error. In that case it's necessary to set the correct permissions on the cache, logs and sessions folders. 

```
rm -rf var/cache/*
rm -rf var/logs/*
rm -rf var/sessions/*

HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var/cache var/logs var/sessions
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var/cache var/logs  var/sessions
```
Update the assets:
```
php bin/console assets:install 
```
Finally, clear the cache:
```
php bin/console cache:clear --env=prod --no-debug
```
###Firebase setup

1. Create a Firebase project in the Firebase console, if you don't already have one. If you already have an existing Google project associated with your app, click Import Google Project. Otherwise, click Create New Project.
2. Click settings and select Permissions.
3. Select Service accounts from the menu on the left.
4. Click Create service account.
  1. Enter a name for your service account. You can optionally customize the ID from the one automatically generated from the name.
  2. Select Furnish a new private key and leave the Key type as JSON.
  3. Leave Enable Google Apps Domain-wide Delegation unselected.
  4. Click Create.

Once you've downloaded the Key JSON file open it in a text editor and copy the ```private_key```. Add this to the ```app/config/parameters.yml``` along with the the ```client_email``` field that should be added as ```firebase_service_account_email```.

**Make sure that the following parameters are encased in speech marks.**
```
firebase_service_account_email: "email here"
firebase_secret: "secret here"
twilio_number: "number here"
```

###Twilio Setup

1. Create a new Twilio account
2. Click "Buy a number". For this trial account, you can choose any number for free. Choose a USA local number that can send SMS to all regions
3. Enable SMS for all the countries you need https://www.twilio.com/user/account/settings/international/sms

Add this number in the ```app/config/parameters.yml``` file.

Open: ```app/config/config.yml```

Add your SID and Auth Token from your Twilio dashboard

```
vresh_twilio:
    #(Required) Your Account SID from www.twilio.com/user/account
    sid: 'ACce16182633c3f0e442499128077*****('
    #(Required) Your Auth Token from www.twilio.com/user/account
    authToken: 'be28ac9e6009dd8ac94520a5fc0*****'
```    