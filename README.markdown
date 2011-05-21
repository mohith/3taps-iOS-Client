# 3taps API iOS Wrapper

The treetapsAPI directory contains the iOS library for the 3taps API wrappers.
At present, this library is released in source-code format; simply copy the
entire contents of the "threetapAPI" directory into your source tree and add it
to your XCode project.  You can then '#include' the necessary interface files
as you need them.

##Configuration

You will need to obtain an API key from http://3taps.com/developers, and configure
your application to use your key by setting it as the value in '3taps API Key' in 
the main plist bundle.

##Pre-requisites

The threetapsAPI library requires the JSON parsing library written by Stig
Brautaset.  Information about this library can be found at:

    http://code.google.com/p/json-framework


##Asynchronous API Calls

All of the 3taps API calls are executed asynchronously.  That is, you ask the
3taps API wrapper to make a call to the 3taps server, and you separately
implement a delegate object which gets sent an appropriate message when the API
call is completed.  Each of the 3taps API client classes has a corresponding
delegate protocol, which you must implement in order to respond to the
completion of an API call.

Note that all the API client delegate methods are optional; you only need to
implement the delegate methods for the particular API call that you wish to
make.  The interface for each API client describes the delegate calls which
can be made in response to that call.


##Unit Testing

Because of the nature of the 3taps iOS API wrappers, it is not possible to use
a standard unit-testing framework for testing the API wrapper classes.
Instead, a series of testing classes have been defined which test out the
functionality of the various API clients.  These testing classes can be found
in the "threetapsAPI/tests" directory, along with a module named "AllTests"
which will run these various testing classes one after the other.

The example application that comes with the threetapsAPI library provides a
minimal user interface that includes a single button.  When the user taps on
this button, the "AllTests" class will be instantiated and run, causing all the
various unit testing classes to be run one after the other.

All the unit tests write their output to the console log, so you can see the
results appear in the XCode console window.


##License

The threetapsAPI library and related files, including the example iPhone
application and the unit tests, are all copyright (c) 2011 3taps inc. 

This software is licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at 

  http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.


