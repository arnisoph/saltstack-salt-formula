# salt-formula

Salt Stack Formula to set up and configure the central system and configuration manager Salt Stack itself

## TODO

* minion/ master: Provide more flexible setting of configuration?
* master: create salt tree (for states and pillar)

## Instructions

1. Add this repository as a [GitFS](http://docs.saltstack.com/topics/tutorials/gitfs.html) backend in your Salt master config.

2. Configure your Pillar top file (`/srv/pillar/top.sls`), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (`/srv/salt/top.sls`).

## Available states

### salt.minion

Installs and configures a minion

### salt.master

Installs and configures a master

## Additional resources

None

## Formula Dependencies

None

## Compatibility

*DOES* work on:

* GNU/ Linux Debian Wheezy

*SHOULD* work on:

* None
