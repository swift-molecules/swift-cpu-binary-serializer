# swift-cpu-binary-serializer

Binary serialization integration for the CPU domain.

This package owns the `Binary.Serializable` conformances for `CPU.Timestamp`
and `CPU.Integrity.Cyclic.Checksum`. Their `UInt64` and `UInt32` raw values are
serialized in the host's native endianness through Binary Serializable's
fixed-width integer implementation.
