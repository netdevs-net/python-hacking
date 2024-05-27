#!/bin/bash

# Constants

b23_pass = "VAfGXJ1PBSsPSnvsjI8p759leLZ9GGar"
4num = 9999

# Variables

i = 0 

# functionality
for $i in 4num {
	newPass = b23_pass + 4num
	nc localhost 30002 newPass
}

# Main
