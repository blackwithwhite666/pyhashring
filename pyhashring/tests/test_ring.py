from __future__ import absolute_import

from pyhashring.tests.base import TestCase
from pyhashring import HashRing


class HashRingTest(TestCase):

    def test_construct(self):
        ring = HashRing()

