from utils cimport emalloc, efree

# Python-style minor error classes.  If the minor error code matches an entry
# in this dict, the generated exception will be used.
_minor_table = {
    H5E_SEEKERROR:      IOError,    # Seek failed 
    H5E_READERROR:      IOError,    # Read failed  
    H5E_WRITEERROR:     IOError,    # Write failed  
    H5E_CLOSEERROR:     IOError,    # Close failed 
    H5E_OVERFLOW:       IOError,    # Address overflowed 
    H5E_FCNTL:          IOError,    # File control (fcntl) failed

    H5E_FILEEXISTS:     IOError,    # File already exists 
    H5E_FILEOPEN:       IOError,    # File already open 
    H5E_CANTCREATE:     IOError,    # Unable to create file
    H5E_CANTOPENFILE:   IOError,    # Unable to open file 
    H5E_CANTCLOSEFILE:  IOError,    # Unable to close file 
    H5E_NOTHDF5:        IOError,    # Not an HDF5 file 
    H5E_BADFILE:        ValueError, # Bad file ID accessed 
    H5E_TRUNCATED:      IOError,    # File has been truncated
    H5E_MOUNT:          IOError,    # File mount error 

    H5E_NOFILTER:       IOError,    # Requested filter is not available 
    H5E_CALLBACK:       IOError,    # Callback failed 
    H5E_CANAPPLY:       IOError,    # Error from filter 'can apply' callback 
    H5E_SETLOCAL:       IOError,    # Error from filter 'set local' callback 
    H5E_NOENCODER:      IOError,    # Filter present but encoding disabled 

    H5E_BADATOM:        ValueError,  # Unable to find atom information (already closed?) 
    H5E_BADGROUP:       ValueError,  # Unable to find ID group information 
    H5E_BADSELECT:      ValueError,  # Invalid selection (hyperslabs)
    H5E_UNINITIALIZED:  ValueError,  # Information is uinitialized 
    H5E_UNSUPPORTED:    NotImplementedError,    # Feature is unsupported 

    H5E_NOTFOUND:       KeyError,    # Object not found 
    H5E_CANTINSERT:     ValueError,   # Unable to insert object 

    H5E_BADTYPE:        TypeError,   # Inappropriate type 
    H5E_BADRANGE:       ValueError,  # Out of range 
    H5E_BADVALUE:       ValueError,  # Bad value

    H5E_EXISTS:         ValueError,  # Object already exists 
    H5E_ALREADYEXISTS:  ValueError,  # Object already exists, part II
    H5E_CANTCONVERT:    TypeError,   # Can't convert datatypes 

    H5E_CANTDELETE:     KeyError,    # Can't delete message

    H5E_CANTOPENOBJ:    KeyError,
  }

# "Fudge" table to accomodate annoying inconsistencies in HDF5's use 
# of the minor error codes.  If a (major, minor) entry appears here,
# it will override any entry in the minor error table.
_exact_table = {
    (H5E_CACHE, H5E_BADVALUE):      IOError,  # obj create w/o write intent 1.8
    (H5E_RESOURCE, H5E_CANTINIT):   IOError,  # obj create w/o write intent 1.6
    (H5E_INTERNAL, H5E_SYSERRSTR):  IOError,  # e.g. wrong file permissions
    (H5E_DATATYPE, H5E_CANTINIT):   TypeError,  # No conversion path
    (H5E_DATASET, H5E_CANTINIT):    ValueError,  # bad param for dataset setup
    (H5E_ARGS, H5E_CANTINIT):       TypeError,  # Illegal operation on object
    (H5E_SYM, H5E_CANTINIT):        ValueError, # Object already exists/1.8
    (H5E_ARGS, H5E_BADTYPE):        ValueError, # Invalid location in file
  }

cdef class err_data_t:
    cdef hid_t cls_id
    cdef hid_t maj_num
    cdef hid_t min_num
    cdef object desc
    cdef int n

cdef herr_t walk_cb(unsigned n, const_H5E_error2_t *desc, void *e):

    cdef err_data_t ee = <err_data_t>e

    ee.cls_id = desc[0].cls_id
    ee.maj_num = desc[0].maj_num
    ee.min_num = desc[0].min_num
    if desc[0].desc is NULL:
        ee.desc = None
    else:
        ee.desc = desc[0].desc
    ee.n = n

cdef object get_error_message(hid_t msg_id):
    """Returns the error code description as a Python str."""
    cdef ssize_t size
    cdef char* mesg

    # Get the size of the message
    size = H5Eget_msg(msg_id, NULL, NULL, 0)
    if size < 0:
        raise RuntimeError("Failed to obtain error code description")

    mesg = <char*>emalloc(sizeof(char)*(size+1))
    try:
        # Read the message
        size = H5Eget_msg(msg_id, NULL, mesg, size+1)
        if size < 0:
            raise RuntimeError("Failed to obtain error code description")

        return mesg.decode('utf-8')
    finally:
        efree(mesg)

cdef int set_exception() except -1:

    cdef err_data_t err = err_data_t()

    err.n = -1

    if H5Ewalk2(H5E_DEFAULT, H5E_WALK_UPWARD, walk_cb, <void*>err) < 0:
        raise RuntimeError("Failed to walk error stack")

    if err.n < 0:   # No HDF5 exception information found
        return 0

    eclass = _minor_table.get(err.min_num, RuntimeError)
    eclass = _exact_table.get((err.maj_num, err.min_num), eclass)

    if err.desc is None:
        raise RuntimeError("Failed to extract detailed error description")

    msg = ("%s (%s: %s)" % (err.desc.decode('utf-8'),
                            get_error_message(err.maj_num),
                            get_error_message(err.min_num))).encode('utf-8')

    PyErr_SetString(eclass, msg)

    return 1

cdef extern from "stdio.h":
    void *stderr

def silence_errors():
    """ Disable HDF5's automatic error printing in this thread """
    if H5Eset_auto2(H5E_DEFAULT, NULL, NULL) < 0:
        raise RuntimeError("Failed to disable automatic error printing")

def unsilence_errors():
    """ Re-enable HDF5's automatic error printing in this thread """
    if H5Eset_auto2(H5E_DEFAULT, <H5E_auto2_t> H5Eprint2, stderr) < 0:
        raise RuntimeError("Failed to enable automatic error printing")

cdef err_cookie set_error_handler(err_cookie handler):
    # Note: exceptions here will be printed instead of raised.

    cdef err_cookie old_handler

    if H5Eget_auto2(H5E_DEFAULT, &old_handler.func, &old_handler.data) < 0:
        raise RuntimeError("Failed to retrieve old handler")

    if H5Eset_auto2(H5E_DEFAULT, handler.func, handler.data) < 0:
        raise RuntimeError("Failed to install new handler")

    return old_handler























