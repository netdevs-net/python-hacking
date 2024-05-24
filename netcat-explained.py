# Short Python Program to create UDP and TCP connections (This is a practice project)
# This program was created on April 28, 2024.

import argparse
import socket
import shlex
import subprocess
import sys
import textwrap
import threading

def execute(cmd):
  """
  Executes a shell command and returns the output as a string.
  """
  cmd = cmd.strip()  # Remove any leading or trailing whitespace from the command.
  if not cmd:
	return
  output = subprocess.check_output(shlex.split(cmd), stderr=subprocess.STDOUT)  # Execute the command and capture output/errors.
  return output.decode()  # Decode the byte output from the subprocess to a string.

class NetCat:
  def __init__(self, args, buffer=None):
	"""
	Initialize the NetCat class with arguments and an optional buffer.

	Args:
	  args: The parsed arguments from the command line.
	  buffer: An optional byte buffer to send during a connection.
	"""
	self.args = args
	self.buffer = buffer
	self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # Create a TCP socket.
	self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # Allow reusing the same address/port combination.

  def run(self):
	"""
	Runs the NetCat program based on whether we're listening or sending data.
	"""
	if self.args.listen:
	  self.listen()
	else:
	  self.send()

  def send(self):
	"""
	Establishes a connection to the target and sends data (if provided) and receives responses in a loop.
	"""
	self.socket.connect((self.args.target, self.args.port))  # Connect to the target IP and port.
	if self.buffer:
	  self.socket.send(self.buffer)  # Send the provided buffer if it exists.

	try:
	  while True:
		recv_len = 1
		response = ''
		while recv_len:  # Continuously receive data until no more data is available.
		  data = self.socket.recv(4096)  # Receive up to 4096 bytes of data at a time.
		  recv_len = len(data)
		  response += data.decode()  # Decode received bytes to a string and add to the response.
		  if recv_len < 4096:  # If less than 4096 bytes were received, we've likely reached the end of the data.
			break
		if response:
		  print(response)  # Print the received response.
		buffer = input('> ')  # Get user input for the next message.
		buffer += '\n'  # Add a newline character to the user input.
		self.socket.send(buffer.encode())  # Encode and send the user input.
	except KeyboardInterrupt:
	  print('User Terminated')
	  self.socket.close()  # Close the socket on keyboard interrupt.
	  sys.exit()

  def listen(self):
	"""
	Listens for incoming connections on the specified port and handles them in separate threads.
	"""
	self.socket.bind((self.args.target, self.args.port))  # Bind the socket to the target IP and port.
	self.socket.listen(5)  # Listen for incoming connections with a backlog of 5.
	while True:
	  client_socket, _ = self.socket.accept()  # Accept an incoming connection and get the client socket.
	  client_thread = threading.Thread(target=self.handle, args=(client_socket,))  # Create a thread to handle the client connection.
	  client_thread.start()  # Start the thread.

	  while True:
		  data = client_socket.recv(4096)  # Receive data from the client in chunks of 4096 bytes.
		  if data:
			file_buffer += data  # Append received data to the file buffer.
		  else:  
			break  # If no data is received, we've likely reached the end of the file.
		with open(self.args.upload, 'wb') as f:
		  f.write(file_buffer)  # Write the accumulated data buffer to the specified upload file in binary write mode.
		message = f'Saved file: {self.args.upload}'  # Create a success message indicating the uploaded file.
		client_socket.send(message.encode())  # Send the success message to the client.
	  elif self.args.command:
		cmd_buffer = b''
		while True:
		  try:
			client_socket.send(b'python-hacking: #> ')  # Send a prompt to the client for command input.
			while '\n' not in cmd_buffer.decode():  # Continuously receive data until a newline character is encountered.
			  cmd_buffer += client_socket.recv(64)  # Receive data in chunks of 64 bytes.
			response = execute(cmd_buffer.decode())  # Decode the received command buffer and execute it.
			if response:
			  client_socket.send(response.encode())  # Send the command execution output to the client.
			cmd_buffer = b''  # Reset the command buffer for the next command.
		  except Exception as e:
			print(f'server closed {e}')  # Print any exceptions that occur.
			self.socket.close()  # Close the socket on errors.
			sys.exit()
  def listen(self):
				"""
	Listens for incoming connections on the specified port and handles them in separate threads.
	"""
	self.socket.bind((self.args.target, self.args.port))  # Bind the socket to the target IP and port.
	self.socket.listen(5)  # Listen for incoming connections with a backlog of 5.
	while True:
	  client_socket, _ = self.socket.accept()  # Accept an incoming connection and get the client socket.
	  client_thread = threading.Thread(target=self.handle, args=(client_socket,))  # Create a thread to handle the client connection.
	  client_thread.start()  # Start the thread.

  def handle(self, client_socket):
	"""
	Handles a connected client based on the provided arguments (execute, upload, or command shell).
	"""
	if self.args.execute:
	  output = execute(self.args.execute)  # Execute the specified command and capture the output.
	  client_socket.send(output.encode())  # Send the command output to the client.
	elif self.args.upload:
	  file_buffer = b''
	  while