P4 programs can also interact with objects and functions provided by the
architecture. Such objects are described using the `extern` construct,
which describes the interfaces that such objects expose to the
data-plane.

An `extern` object describes a set of methods that are implemented by an
object, but not the implementation of these methods (i.e., it is similar
to an abstract class in an object-oriented language). For example, the
following construct could be used to describe the operations offered by
an incremental checksum unit:

\~ Begin P4Example extern Checksum16 { Checksum16(); // constructor void
clear(); // prepare unit for computation void update<T>(in T data); //
add data to checksum void remove<T>(in T data); // remove data from
existing checksum bit\<16\> get(); // get the checksum for the data
added since last clear } \~ End P4Example
