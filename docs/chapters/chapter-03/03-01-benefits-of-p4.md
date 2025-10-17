Compared to state-of-the-art packet-processing systems (e.g., based on
writing microcode on top of custom hardware), P4 provides a number of
significant advantages:

  - **Flexibility**: P4 makes many packet-forwarding policies
    expressible as programs, in contrast to traditional switches, which
    expose fixed-function forwarding engines to their users.
  - **Expressiveness**: P4 can express sophisticated,
    hardware-independent packet processing algorithms using solely
    general-purpose operations and table look-ups. Such programs are
    portable across hardware targets that implement the same
    architectures (assuming sufficient resources are available).
  - **Resource mapping and management**: P4 programs describe storage
    resources abstractly (e.g., IPv4 source address); compilers map such
    user-defined fields to available hardware resources and manage
    low-level details such as allocation and scheduling.
  - **Software engineering**: P4 programs provide important benefits
    such as type checking, information hiding, and software reuse.
  - **Component libraries**: Component libraries supplied by
    manufacturers can be used to wrap hardware-specific functions into
    portable high-level P4 constructs.
  - **Decoupling hardware and software evolution**: Target manufacturers
    may use abstract architectures to further decouple the evolution of
    low-level architectural details from high-level processing.
  - **Debugging**: Manufacturers can provide software models of an
    architecture to aid in the development and debugging of P4 programs.
