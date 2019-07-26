# XMPP Chat SDK for iOS - Installation

The XMPP Chat SDK is a module that enables XMPP chat for the popular Chat SDK for iOS Messaging Framework. 

The Chat SDK provides:

+ User interface
+ Data persistence

The XMPP module then provides a network adapter which allows the Chat SDK UI to communicate with an XMPP server. 

## Server setup
The XMPP Chat SDK uses ejabberd as it's default back end. First got to the ejabberd website and download the [Community Version](https://www.process-one.net/en/ejabberd/#getejabberd).

Follow the instructions on the ejabberd site to install ejabberd on your server.  

Once the server is setup, you need to change some settings:

#### Enable registration

Change the ejabberd configuration 
`conf/ejabberd.yml`

```
trusted_network:
    allow: all
	
local: 
    all: allow
    
mod_vcard: 
    search: true
    matches: 10
    allow_return_all: true
```

Start ejabberd by going to the installation directory on your server and running:

```
sudo sh bin/ejabberdctl start
```

You can check that ejabberd is up and running by logging in to the server admin:

```
http://your-server.com:5280/admin
```

## Client setup

The XMPP Chat SDK zip file contains everything you need to compile and run the project. However, a few steps are needed before you can compile the project. 

Use the terminal to navigate to the `XcodeXMPP` folder. Then run `pod install`. This will install the project using Cocoapods. 

> **Note:**
>When you try to compile the project you may see bit code errors. To resolve this you need to disable bit code. Click the `ChatSDK Demo` target and in `Build Settings` search for `bitcode`. Set this to `No`. Now do the same for the `Pods` target and each of the targets inside the `Pods` sub project. 

Now it's necessary to set the default XMPP server for the client. Open the `info.plist` file and find the xmpp settings: **chat_sdk** -> **xmpp**

Here you can set the following values:

```
server_host: your.server.com
server_port: 0
roster_search_path: vjud
```

If the server port is set to zero, the default value will be used. The `roster_search_path` is the service name which is used to search the roster. On ejabberd the default value is `vjud`. 

By default the SDK is setup to use Backendless to handle push notifications and file uploads. 

You can find instructions to setup Backendless on the main [Chat SDK project site](https://github.com/chat-sdk/chat-sdk-ios/). 






