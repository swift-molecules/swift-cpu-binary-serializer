import Binary_Serializable
import enum Binary.Binary
import enum CPU.CPU
import CPU_Binary_Serializer
import Testing

private func serializedBytes<Value: Binary.Serializable>(_ value: Value) -> [UInt8] {
    var bytes: [UInt8] = []
    value.serialize(into: &bytes)
    return bytes
}

@Suite
struct `CPU Binary Serializer Tests` {
    @Test
    func `Timestamp serializes its UInt64 raw value`() {
        let bytes = serializedBytes(CPU.Timestamp(0x0102_0304_0506_0708))

        #if _endian(little)
            #expect(bytes == [0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01])
        #else
            #expect(bytes == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        #endif
    }

    @Test
    func `Cyclic checksum serializes its UInt32 raw value`() {
        let bytes = serializedBytes(CPU.Integrity.Cyclic.Checksum(0x0102_0304))

        #if _endian(little)
            #expect(bytes == [0x04, 0x03, 0x02, 0x01])
        #else
            #expect(bytes == [0x01, 0x02, 0x03, 0x04])
        #endif
    }

    @Test
    func `Serialization appends instead of replacing`() {
        var bytes: [UInt8] = [0xFF]

        CPU.Timestamp(0).serialize(into: &bytes)

        #expect(bytes == [0xFF, 0, 0, 0, 0, 0, 0, 0, 0])
    }
}
