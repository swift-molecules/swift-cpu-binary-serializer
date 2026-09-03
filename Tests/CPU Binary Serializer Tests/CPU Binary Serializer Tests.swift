import Binary_Serializable
import Byte
import enum Binary.Binary
import enum CPU.CPU
import CPU_Binary_Serializer
import Testing

private func serializedBytes<Value: Binary.Serializable>(_ value: Value) -> [Byte] {
    var bytes: [Byte] = []
    value.serialize(into: &bytes)
    return bytes
}

private func bytes(_ patterns: UInt8...) -> [Byte] {
    patterns.map(Byte.init(bitPattern:))
}

@Suite
struct `CPU Binary Serializer Tests` {
    @Test
    func `Timestamp serializes its UInt64 raw value`() {
        let serialized = serializedBytes(CPU.Timestamp(0x0102_0304_0506_0708))

        #if _endian(little)
            #expect(serialized == bytes(0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01))
        #else
            #expect(serialized == bytes(0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08))
        #endif
    }

    @Test
    func `Cyclic checksum serializes its UInt32 raw value`() {
        let serialized = serializedBytes(CPU.Integrity.Cyclic.Checksum(0x0102_0304))

        #if _endian(little)
            #expect(serialized == bytes(0x04, 0x03, 0x02, 0x01))
        #else
            #expect(serialized == bytes(0x01, 0x02, 0x03, 0x04))
        #endif
    }

    @Test
    func `Serialization appends instead of replacing`() {
        var serialized = bytes(0xFF)

        CPU.Timestamp(0).serialize(into: &serialized)

        #expect(serialized == bytes(0xFF, 0, 0, 0, 0, 0, 0, 0, 0))
    }
}
