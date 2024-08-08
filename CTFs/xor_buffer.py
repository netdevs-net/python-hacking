import binascii
import base64

def xor_buffers(buffer1: bytes, buffer2: bytes) -> bytes:
	
	if len(buffer1) != len(buffer2):
		raise ValueError("Buffers must be equal length")
		
	xor_result = bytes(b1 ^ b2 for b1,b2 in zip(buffer1,buffer2))
	return xor_result
	

buffer1 = byte