lancat
======

Introduction
------------

lancat allows simple zero-configuration file transfer over a local area
network.

As a quick example - to send `hello.txt` from machine A to machine B, the
following command should be executed on the sending machine (A):

    lancat -s < hello.txt

and the following command should be executed on receiving machine (B):

    lancat -r > hello.txt

The two commands can be executed in any order - either one will wait for the
other.

There is no need to remember or figure out the IP address of the other machine,
so this is particularly useful for a quick file transfer on networks where DHCP
is used.

However, be warned: on a shared network, you should not use lancat to transfer
confidential data (unless you combine it with a command to do encryption - see
the example below) - the data is transferred in the clear. Furthermore, anybody
else on your local network could run a `lancat` command before you do so on the
second machine, and lancat will happily send your data to them instead. Oops!

Installation
------------

You'll need [Ruby 1.9 or above][ruby] on your machine. lancat is a Ruby gem so
it can simply be installed with the following command:

    gem install lancat

You may need to use `sudo` or `su` to install it as the root user.

Rubygems should automatically add the executable to your `$PATH`, so after
installing the gem, running `lancat` should just work.

More examples
-------------

### Show status of the transfer with `pv`

If you are transferring a large file, you could use `pv` command on the sender
to monitor the progress of the transfer:

    pv hello.txt | lancat -s

or if you wanted to see the progress on the receiver:

    lancat -r | pv > hello.txt

However, on the receiving end, `pv` will probably not be able to make a guess
of the total file size, so you'll only be able to see the rate of the transfer.
Therefore, it's probably better to use `pv` on the sending machine.

### Transfer several files at once with `tar`

lancat is only capable of sending a single file at once. However, it can be
combined with `tar` to send several files. On the sender:

    tar cf - file1.txt file2.txt file3.txt | lancat -s

and on the receiver:

    lancat -r | tar xf -

### Compress large files

For sending large files over a slow network, a compression program such as
`gzip`, `bzip2`, `lzma`, `xz`, etc. could be used. On the sender:

    xz -c really_big_file.dat | lancat -s

and on the receiver:

    lancat -r | xz -dc > really_big_file.dat

### Symmetric encryption

Despite the warning in the introduction, if you insist on using lancat to send
confidential data, you could combine it with a program that performs symmetric
encryption such as OpenSSL. On the sender:

    openssl aes-256-cbc -in nuclear_launch_codes.txt | lancat -s

and on the receiver:

    lancat -r | openssl aes-256-cbc -d -out nuclear_launch_codes.txt

Once you've entered the passphrase on both ends, the transfer will commence but
if anybody does try to sniff the traffic, or sneakily run the `lancat` command
on their own machine before you can run on it your second machine, they'll see
the cipher text instead of the plain text.

### X11 clipboard

The `xclip` command could be used to send the contents of the clipboard over
the network - I frequently need way to copy complicated URLs between machines.
On the sender:

    xclip -o -selection clipboard | lancat -s

and on the receiver:

    lancat -r | xclip -i -selection clipboard

### and more...?

As lancat follows the 'UNIX philosophy' of doing one thing well and being
usable within a shell pipeline, I'm sure there are many other cool things that
could be done with it. If you come up with anything particularly good, which
other people may find useful, then let me know and I'll include it in this
documentation.

How it works
------------

The sender opens a TCP server socket on a random port. It then sends out UDP
multicast packets every second, which contain the server socket's port number,
until the receiver connects to the server socket, or the timeout has passed.

The receiver waits to receive one of these UDP multicast packets. Once it has
done so, it opens a TCP client socket. It connects the socket to the IP address
the UDP packet was from, and to the port contained within the UDP packet.

After both sides have established the TCP connection, the sender sends all the
data from `stdin` to the receiver. The receiver writes everything it receives to
`stdout`. Once they reach the end of the file, the socket is closed and both
programs terminate.

But it doesn't concatenate!
---------------------------

Yes, but lancat sounds cooler, and it is easier to say than lancp.

License
-------

lancat is released under the [ISC license][isc]. See the `LICENSE` file for the
copyright notice and license text.

[ruby]: http://www.ruby-lang.org/
[isc]: http://www.tldrlegal.com/license/isc-license
