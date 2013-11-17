=========================================
pyhashring - python wrapper for hash ring
=========================================

CI status: |cistatus|

.. |cistatus| image:: https://secure.travis-ci.org/blackwithwhite666/pyhashring.png?branch=master

This library is a thin python wrapper around hash ring implementation in https://github.com/chrismoos/hash-ring

Installing
==========

pyhashring can be installed via pypi:

::

    pip install pyhashring


Building
========

Get the source:

::

    git clone https://github.com/blackwithwhite666/pyhashring.git


Compile extension:

::

     python setup.py build_ext --inplace



Usage
=====



Running the test suite
======================

Use Tox to run the test suite:

::

    tox
