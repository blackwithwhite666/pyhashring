from libc.stdlib cimport malloc, free
from libc.stdint cimport uint8_t, uint32_t


cdef extern from "hash_ring.h":

    ctypedef struct hash_ring_t:
        pass

    ctypedef struct hash_ring_node_t:
        uint8_t *name
        uint32_t nameLen

    ctypedef uint8_t HASH_FUNCTION
    ctypedef uint8_t HASH_MODE

    cdef uint8_t HASH_FUNCTION_SHA1
    cdef uint8_t HASH_FUNCTION_MD5

    cdef uint8_t HASH_RING_OK
    cdef uint8_t HASH_RING_ERR

    cdef uint8_t HASH_RING_DEBUG

    hash_ring_t *hash_ring_create(uint32_t numReplicas, HASH_FUNCTION hash_fn)
    void hash_ring_free(hash_ring_t *ring)
    int hash_ring_add_node(hash_ring_t *ring, uint8_t *name, uint32_t nameLen)
    hash_ring_node_t *hash_ring_get_node(hash_ring_t *ring, uint8_t *name, uint32_t nameLen)
    hash_ring_node_t *hash_ring_find_node(hash_ring_t *ring, uint8_t *key, uint32_t keyLen)
    int hash_ring_remove_node(hash_ring_t *ring, uint8_t *name, uint32_t nameLen)
    void hash_ring_print(hash_ring_t *ring)


cdef class HashRing(object):
    cdef hash_ring_t *_c_ring

    def __cinit__(self, int num_replicas=1):
        assert num_replicas > 0, "num_replicas too small"
        self._c_ring = hash_ring_create(num_replicas, HASH_FUNCTION_MD5)
        if self._c_ring is NULL:
            raise MemoryError("Can't allocate memory for ring!")

    def __dealloc__(self):
        if self._c_ring is not NULL:
            hash_ring_free(self._c_ring)

    def __contains__(self, bytes name):
        cdef hash_ring_node_t *node = hash_ring_get_node(self._c_ring, name, len(name))
        return node is not NULL

    def dump(self):
        hash_ring_print(self._c_ring)

    def get(self, bytes name):
        cdef hash_ring_node_t *node = hash_ring_get_node(self._c_ring, name, len(name))
        if node is NULL:
            raise KeyError("Name not exists!")
        return <bytes>node.name[:node.nameLen]

    def add(self, bytes name):
        if name in self:
            return False
        cdef int rc = hash_ring_add_node(self._c_ring, name, len(name))
        if rc != HASH_RING_OK:
            raise RuntimeError("Can't add new node!")
        return True

    def find(self, bytes key):
        cdef hash_ring_node_t *node = hash_ring_find_node(self._c_ring, key, len(key))
        if node is NULL:
            raise RuntimeError("Can't find given node!")
        return <bytes>node.name[:node.nameLen]

    def remove(self, bytes name):
        if name not in self:
            return False
        cdef int rc = hash_ring_remove_node(self._c_ring, name, len(name))
        if rc != HASH_RING_OK:
            raise RuntimeError("Can't remove given node!")
        return True

