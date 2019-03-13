#!/usr/bin/python

import sys
import time

# Send back the received line
print("Received", "First line")

# Lets send back the current time just so we have more than one
# line of output.
print("Current time is", time.ctime())

# Now send our terminating string to end the transaction.
print("OK")

# And finally, lets flush stdout because we are communicating with
# Erlang via a pipe which is normally fully buffered.
sys.stdout.flush()
