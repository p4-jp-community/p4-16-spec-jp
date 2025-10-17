# Appendix E Checksums


There are no built-in constructs in P4<sub>16</sub> for manipulating
packet checksums. We expect that checksum operations can be expressed as
`extern` library objects that are provided in target-specific libraries.
The standard architecture library should provide such checksum units.

For example, one could provide an incremental checksum unit `Checksum16`
(also described in the VSS example in Section \[\#sec-vss-extern\]) for
computing 16-bit one’s complement using an `extern` object with a
signature such as:

\~ Begin P4Example extern Checksum16 { Checksum16(); // constructor void
clear(); // prepare unit for computation void update<T>(in T data); //
add data to checksum void remove<T>(in T data); // remove data from
existing checksum bit\<16\> get(); // get the checksum for the data
added since last clear } \~ End P4Example

  - IP checksum verification could be done in a parser as:  
    Begin P4Example ck16.clear(); // prepare checksum unit
    ck16.update(h.ipv4); // write header verify(ck16.get() == 16w0,
    error.IPv4ChecksumError); // check for 0 checksum
    
    End P4Example

  - IP checksum generation could be done as:  
    Begin P4Example h.ipv4.hdrChecksum = 16w0; ck16.clear();
    ck16.update(h.ipv4); h.ipv4.hdrChecksum = ck16.get();
    
    End P4Example

Moreover, some switch architectures do not perform checksum
verification, but only update checksums incrementally to reflect packet
modifications. This could be achieved as well, as the following P4
program fragments illustrates:

\~ Begin P4Example ck16.clear(); ck16.update(h.ipv4.hdrChecksum); //
original checksum ck16.remove( { h.ipv4.ttl, h.ipv4.proto } );
h.ipv4.ttl = h.ipv4.ttl - 1; ck16.update( { h.ipv4.ttl, h.ipv4.proto }
); h.ipv4.hdrChecksum = ck16.get(); \~ End P4Example

