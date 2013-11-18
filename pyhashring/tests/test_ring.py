from __future__ import absolute_import

from pyhashring.tests.base import TestCase
from pyhashring import HashRing, MD5, SHA1


class HashRingTest(TestCase):

    def setUp(self):
        super(HashRingTest, self).setUp()
        self.ring = HashRing()

    def test_add(self):
        self.assertTrue(self.ring.add(b'redis01'))
        self.assertEqual(1, self.ring.nodes)
        self.assertTrue(self.ring.add(b'redis02'))
        self.assertEqual(2, self.ring.nodes)
        self.assertFalse(self.ring.add(b'redis02'))
        self.assertEqual(2, self.ring.nodes)

    def test_find(self):
        ring = HashRing(8, SHA1)
        self.assertEqual(8, ring.replicas)
        self.assertEqual(SHA1, ring.hash_func)
        slot_a = b'slotA'
        slot_b = b'slotB'
        self.assertTrue(ring.add(slot_a))
        self.assertTrue(ring.add(slot_b))
        self.assertEqual(slot_a, ring.find(b'keyA'))
        self.assertEqual(slot_a, ring.find(b'keyBBBB'))
        self.assertEqual(slot_b, ring.find(b'keyB_'))

    def test_remove(self):
        self.assertEqual(0, self.ring.nodes)
        self.assertTrue(self.ring.add(b'slotA'))
        self.assertEqual(1, self.ring.nodes)
        self.assertTrue(self.ring.remove(b'slotA'))
        self.assertEqual(0, self.ring.nodes)
        self.assertFalse(self.ring.remove(b'slotA'))

