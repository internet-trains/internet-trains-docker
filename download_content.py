# This python script runs a copy of the server to download the nessecary content.

from subprocess import Popen, PIPE
import fcntl, os
import time
import re

default_content = ['13956279'] # Superlib for NoGo
new_content = []
content = default_content + new_content

openttd_shell = Popen(['./openttd', '-D', '-c', 'cdn.cfg'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
# fcntl.fcntl(openttd_shell.stdout.fileno(), fcntl.F_SETFL, os.O_NONBLOCK)

map_complete_string = b'Map generated'

# Create + Load map to enable Admin Console
while True:
    console_log = openttd_shell.stderr.readline()
    if map_complete_string in console_log:
        break

time.sleep(2)
print("Server Started.")

openttd_shell.stdin.write(b'content update\n')
openttd_shell.stdin.flush()
while True:
    console_log = openttd_shell.stdout.readline()
    if b"Content server connection" in console_log:
        break

time.sleep(2)
print("Connected to content server.")

for c in content:
    openttd_shell.stdin.write(b'content select %b\n' % bytes(c, 'ascii'))
    openttd_shell.stdin.flush()

print("Selected Content.")

time.sleep(1)
openttd_shell.stdin.write(b'content download\n')
openttd_shell.stdin.flush()

number_files_text = openttd_shell.stdout.readline()
number_of_files_to_dl = int(re.search('\\d+', str(number_files_text))[0])

print("Downloading %d dependencies." % number_of_files_to_dl)

while True:
    if number_of_files_to_dl == 0:
        break

    console_log = openttd_shell.stdout.readline()
    if b'Completed' in console_log:
        number_of_files_to_dl -= 1

openttd_shell.stdin.write(b'exit\n')
time.sleep(5)
openttd_shell.terminate()

print("Assets downloaded.")
