from libc.stdlib cimport malloc, free
from libc.stdint cimport uint8_t, uint32_t


cdef extern from "hash_ring.h":

    ctypedef struct hash_ring_t:
        pass

    ctypedef uint8_t HASH_FUNCTION
    cdef uint8_t HASH_FUNCTION_SHA1
    cdef uint8_t HASH_FUNCTION_MD5

    hash_ring_t *hash_ring_create(uint32_t numReplicas, HASH_FUNCTION hash_fn)
    void hash_ring_free(hash_ring_t *ring)


cdef class HashRing(object):
    cdef hash_ring_t *_c_ring

    def __cinit__(self, num_replicas=1):
        assert num_replicas > 0, "num_replicas too small"
        self._c_ring = hash_ring_create(1, HASH_FUNCTION_SHA1)
        if self._c_ring is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._c_ring is not NULL:
            hash_ring_free(self._c_ring)
