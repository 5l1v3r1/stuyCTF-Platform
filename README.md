stuyCTF Platform
==============

The stuyCTF Platform is a modified version of [picoCTF Platform 2](https://github.com/picoCTF/picoCTF-Platform-2) for running the stuyCTF competition.

stuyCTF targets Ubuntu 14.04 LTS but should work on just about any "standard" Linux distribution. It would probably even work on Windows. MongoDB must be installed; all default configurations should work.

Setting Up The Development Environment
------------
1. Download VirtualBox (easiest, though others can work)
2. Download Vagrant (vagrantup.com)
3. `vagrant up` inside the repo
4. Wait 20 minutes
5. `vagrant ssh` to connect to the VM
6. Run `devploy` to deploy the development version of the site
7. Go to port 8080 on the Host Machine

*Note*: The competition has two modes: competition active and competition inactive. In inactive mode, there are no problems and only registration is available. To change what mode the competition is in, edit api/api/config.py and change the competition dates such that the current date is either inside or outside the range of the competition dates.

Setting Up The Production Server
------------
1. `cd scripts` inside the repo
2. `./server-setup.sh` to configure server environment
3. Run `devploy` to deploy the site

Loading Problems
------------
1. Clone a copy of https://github.com/stuyCTF/stuyctf into the same parent directory of this
2. Follow instructions to create and deploy problems in the stuyctf repository
3. Run `reload_problems.sh`


Running the Regression Tests
----------------------------

The platform comes with a series of regression tests that should be run before any change is committed to the API.
To run the tests:

1. `vagrant ssh` into your virtual machine.
2. Run `devploy` to bring up an instance from your latest code.
3. To be able to import the API, `cd api` and run the tests with `./run_tests.sh`

All tests should pass with your changes.
