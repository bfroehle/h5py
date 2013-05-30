from api_types_hdf5 cimport *

# Auto-set exception.  Returns 1 if exception set, 0 if no HDF5 error found.
cdef int set_exception() except -1

cdef extern from "hdf5.h":

  ####################
  # Major error codes
  ####################

  hid_t H5E_DATASET       # Dataset
  hid_t H5E_FUNC          # Function entry/exit
  hid_t H5E_STORAGE       # Data storage
  hid_t H5E_FILE          # File accessability
  hid_t H5E_SOHM          # Shared Object Header Messages
  hid_t H5E_SYM           # Symbol table
  hid_t H5E_VFL           # Virtual File Layer
  hid_t H5E_INTERNAL      # Internal error (too specific to document in detail)
  hid_t H5E_BTREE         # B-Tree node
  hid_t H5E_REFERENCE     # References
  hid_t H5E_DATASPACE     # Dataspace
  hid_t H5E_RESOURCE      # Resource unavailable
  hid_t H5E_PLIST         # Property lists
  hid_t H5E_LINK          # Links
  hid_t H5E_DATATYPE      # Datatype
  hid_t H5E_RS            # Reference Counted Strings
  hid_t H5E_HEAP          # Heap
  hid_t H5E_OHDR          # Object header
  hid_t H5E_ATOM          # Object atom
  hid_t H5E_ATTR          # Attribute
  hid_t H5E_NONE_MAJOR    # No error
  hid_t H5E_IO            # Low-level I/O
  hid_t H5E_SLIST         # Skip Lists
  hid_t H5E_EFL           # External file list
  hid_t H5E_TST           # Ternary Search Trees
  hid_t H5E_ARGS          # Invalid arguments to routine
  hid_t H5E_ERROR         # Error API
  hid_t H5E_PLINE         # Data filters
  hid_t H5E_FSPACE        # Free Space Manager
  hid_t H5E_CACHE         # Object cache

  ####################
  # Minor error codes
  ####################

  # Generic low-level file I/O errors
  hid_t H5E_SEEKERROR     # Seek failed
  hid_t H5E_READERROR     # Read failed
  hid_t H5E_WRITEERROR    # Write failed
  hid_t H5E_CLOSEERROR    # Close failed
  hid_t H5E_OVERFLOW      # Address overflowed
  hid_t H5E_FCNTL         # File control (fcntl) failed

  # Resource errors
  hid_t H5E_NOSPACE       # No space available for allocation
  hid_t H5E_CANTALLOC     # Can't allocate space
  hid_t H5E_CANTCOPY      # Unable to copy object
  hid_t H5E_CANTFREE      # Unable to free object
  hid_t H5E_ALREADYEXISTS # Object already exists
  hid_t H5E_CANTLOCK      # Unable to lock object
  hid_t H5E_CANTUNLOCK    # Unable to unlock object
  hid_t H5E_CANTGC        # Unable to garbage collect
  hid_t H5E_CANTGETSIZE   # Unable to compute size
  hid_t H5E_OBJOPEN       # Object is already open

  # Heap errors
  hid_t H5E_CANTRESTORE   # Can't restore condition
  hid_t H5E_CANTCOMPUTE   # Can't compute value
  hid_t H5E_CANTEXTEND    # Can't extend heap's space
  hid_t H5E_CANTATTACH    # Can't attach object
  hid_t H5E_CANTUPDATE    # Can't update object
  hid_t H5E_CANTOPERATE   # Can't operate on object

  # Function entry/exit interface errors
  hid_t H5E_CANTINIT      # Unable to initialize object
  hid_t H5E_ALREADYINIT   # Object already initialized
  hid_t H5E_CANTRELEASE   # Unable to release object

  # Property list errors
  hid_t H5E_CANTGET       # Can't get value
  hid_t H5E_CANTSET       # Can't set value
  hid_t H5E_DUPCLASS      # Duplicate class name in parent class
  hid_t H5E_SETDISALLOWED # Disallowed operation

  # Free space errors
  hid_t H5E_CANTMERGE     # Can't merge objects
  hid_t H5E_CANTREVIVE    # Can't revive object
  hid_t H5E_CANTSHRINK    # Can't shrink container

  # Object header related errors
  hid_t H5E_LINKCOUNT     # Bad object header link count
  hid_t H5E_VERSION       # Wrong version number
  hid_t H5E_ALIGNMENT     # Alignment error
  hid_t H5E_BADMESG       # Unrecognized message
  hid_t H5E_CANTDELETE    # Can't delete message
  hid_t H5E_BADITER       # Iteration failed
  hid_t H5E_CANTPACK      # Can't pack messages
  hid_t H5E_CANTRESET     # Can't reset object
  hid_t H5E_CANTRENAME    # Unable to rename object

  # System level errors
  hid_t H5E_SYSERRSTR     # System error message

  # I/O pipeline errors
  hid_t H5E_NOFILTER      # Requested filter is not available
  hid_t H5E_CALLBACK      # Callback failed
  hid_t H5E_CANAPPLY      # Error from filter 'can apply' callback
  hid_t H5E_SETLOCAL      # Error from filter 'set local' callback
  hid_t H5E_NOENCODER     # Filter present but encoding disabled
  hid_t H5E_CANTFILTER    # Filter operation failed

  # Group related errors
  hid_t H5E_CANTOPENOBJ   # Can't open object
  hid_t H5E_CANTCLOSEOBJ  # Can't close object
  hid_t H5E_COMPLEN       # Name component is too long
  hid_t H5E_PATH          # Problem with path to object

  # No error
  hid_t H5E_NONE_MINOR    # No error

  # File accessability errors
  hid_t H5E_FILEEXISTS    # File already exists
  hid_t H5E_FILEOPEN      # File already open
  hid_t H5E_CANTCREATE    # Unable to create file
  hid_t H5E_CANTOPENFILE  # Unable to open file
  hid_t H5E_CANTCLOSEFILE # Unable to close file
  hid_t H5E_NOTHDF5       # Not an HDF5 file
  hid_t H5E_BADFILE       # Bad file ID accessed
  hid_t H5E_TRUNCATED     # File has been truncated
  hid_t H5E_MOUNT         # File mount error

  # Object atom related errors
  hid_t H5E_BADATOM       # Unable to find atom information (already closed?)
  hid_t H5E_BADGROUP      # Unable to find ID group information
  hid_t H5E_CANTREGISTER  # Unable to register new atom
  hid_t H5E_CANTINC       # Unable to increment reference count
  hid_t H5E_CANTDEC       # Unable to decrement reference count
  hid_t H5E_NOIDS         # Out of IDs for group

  # Cache related errors
  hid_t H5E_CANTFLUSH     # Unable to flush data from cache
  hid_t H5E_CANTSERIALIZE # Unable to serialize data from cache
  hid_t H5E_CANTLOAD      # Unable to load metadata into cache
  hid_t H5E_PROTECT       # Protected metadata error
  hid_t H5E_NOTCACHED     # Metadata not currently cached
  hid_t H5E_SYSTEM        # Internal error detected
  hid_t H5E_CANTINS       # Unable to insert metadata into cache
  hid_t H5E_CANTPROTECT   # Unable to protect metadata
  hid_t H5E_CANTUNPROTECT # Unable to unprotect metadata
  hid_t H5E_CANTPIN       # Unable to pin cache entry
  hid_t H5E_CANTUNPIN     # Unable to un-pin cache entry
  hid_t H5E_CANTMARKDIRTY # Unable to mark a pinned entry as dirty
  hid_t H5E_CANTDIRTY     # Unable to mark metadata as dirty
  hid_t H5E_CANTEXPUNGE   # Unable to expunge a metadata cache entry
  hid_t H5E_CANTRESIZE    # Unable to resize a metadata cache entry

  # Parallel MPI errors
  hid_t H5E_MPI           # Some MPI function failed
  hid_t H5E_MPIERRSTR     # MPI Error String
  hid_t H5E_CANTRECV      # Can't receive data

  # Dataspace errors
  hid_t H5E_CANTCLIP      # Can't clip hyperslab region
  hid_t H5E_CANTCOUNT     # Can't count elements
  hid_t H5E_CANTSELECT    # Can't select hyperslab
  hid_t H5E_CANTNEXT      # Can't move to next iterator location
  hid_t H5E_BADSELECT     # Invalid selection
  hid_t H5E_CANTCOMPARE   # Can't compare objects

  # Argument errors
  hid_t H5E_UNINITIALIZED # Information is uinitialized
  hid_t H5E_UNSUPPORTED   # Feature is unsupported
  hid_t H5E_BADTYPE       # Inappropriate type
  hid_t H5E_BADRANGE      # Out of range
  hid_t H5E_BADVALUE      # Bad value

  # B-tree related errors
  hid_t H5E_NOTFOUND      # Object not found
  hid_t H5E_EXISTS        # Object already exists
  hid_t H5E_CANTENCODE    # Unable to encode value
  hid_t H5E_CANTDECODE    # Unable to decode value
  hid_t H5E_CANTSPLIT     # Unable to split node
  hid_t H5E_CANTREDISTRIBUTE # Unable to redistribute records
  hid_t H5E_CANTSWAP      # Unable to swap records
  hid_t H5E_CANTINSERT    # Unable to insert object
  hid_t H5E_CANTLIST      # Unable to list node
  hid_t H5E_CANTMODIFY    # Unable to modify record
  hid_t H5E_CANTREMOVE    # Unable to remove object

  # Datatype conversion errors
  hid_t H5E_CANTCONVERT   # Can't convert datatypes
  hid_t H5E_BADSIZE       # Bad size for object

  cdef enum H5E_direction_t:
    H5E_WALK_UPWARD    = 0      # begin deep, end at API function
    H5E_WALK_DOWNWARD = 1       # begin at API function, end deep

  ctypedef struct H5E_error2_t:
    hid_t       cls_id         # class ID
    hid_t       maj_num        # major error ID
    hid_t       min_num        # minor error number
    unsigned    line           # line in file where error occurs
    char        *func_name     # function in which error occurred
    char        *file_name     # file in which error occurred
    char        *desc          # optional supplied description

  hid_t H5E_DEFAULT
  cdef enum H5E_type_t:
    H5E_MAJOR
    H5E_MINOR

  # HDF5 error class
  hid_t H5E_ERR_CLS

  ssize_t   H5Eget_msg(hid_t msg_id, H5E_type_t *type, char *msg, size_t size)
  herr_t    H5Eclear2(hid_t estack_id) except *

  ctypedef herr_t (*H5E_auto2_t)(hid_t estack_id, void *client_data)
  herr_t    H5Eset_auto2(hid_t estack_id, H5E_auto2_t func, void *client_data)
  herr_t    H5Eget_auto2(hid_t estack_id, H5E_auto2_t *func, void** client_data)

  herr_t    H5Eprint2(hid_t estack_id, void *stream)

  ctypedef H5E_error2_t const_H5E_error2_t "const H5E_error2_t"
  ctypedef herr_t (*H5E_walk2_t)(unsigned n, const_H5E_error2_t *err_desc, void* client_data)
  herr_t    H5Ewalk2(hid_t estack_id, H5E_direction_t direction, H5E_walk2_t func, void* client_data)

# --- Functions for managing the HDF5 error callback mechanism ---

ctypedef struct err_cookie:
    # Defines the error handler state (callback and callback data)
    H5E_auto2_t func
    void *data

# Set (via H5Eset_auto2) the HDF5 error handler for this thread.  Returns
# the old (presently installed) handler.
cdef err_cookie set_error_handler(err_cookie handler)
