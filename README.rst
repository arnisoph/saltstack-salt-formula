============
salt-formula
============

Salt Stack Formula to set up and configure the central system and configuration manager Salt Stack itself

NOTICE BEFORE YOU USE
=====================

* This formula aims to follow the conventions and recommendations described at http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#conventions-formula and http://docs.saltstack.com/en/latest/topics/best_practices.html

TODO
====

* minion/ master: Provide more flexible setting of configuration?
* master: create salt tree (for states and pillar)

Instructions
============

1. Add this repository as a `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_ backend in your Salt master config.

2. Configure your Pillar top file (``/srv/pillar/top.sls``) and your pillars, see pillar.example.sls

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (``/srv/salt/top.sls``).

Available states
================

.. contents::
    :local:

``salt``
--------
Installs the SaltStack software package repository

``salt.master``
---------------
Installs and configures a master

``salt.minion``
---------------
Installs and configures a minion

Additional resources
====================

None

Formula Dependencies
====================

None

Contributions
=============

Contributions are always welcome. All development guidelines you have to know are

* write clean code (proper YAML+Jinja syntax, no trailing whitespaces, no empty lines with whitespaces, LF only)
* set sane default settings
* test your code
* update README.rst doc

Salt Compatibility
==================

Tested with:

* 2014.1.3

OS Compatibility
================

Tested with:

* GNU/ Linux Debian Wheezy 7.5
* CentOS 6.5
