#! /usr/bin/env python

import sys, struct

if (len(sys.argv)<2):
        print "Usage: %s <filename.cov> [<output-file.txt>]" % sys.argv[0];
        exit;
        
filename = sys.argv[1];
cov = open(filename)
# Read the header.
fmt = ">8s1i256s256s1i4d3i4x"
head = cov.read(struct.calcsize(fmt))
l = struct.unpack(fmt, head)
N = l[4] # 248

# Read the indices.
fmt = ">%di" % N
buf = cov.read(struct.calcsize(fmt))
chan_idx = struct.unpack(fmt, buf) # 1,0,7,9...

# Read the covariance matrix.

fmt = ">%dd" % (N * N)
buf = cov.read(struct.calcsize(fmt))
mat = struct.unpack(fmt, buf)

if (len(sys.argv)<3):
        outFileName = filename.replace('.cov', '.txt');
else:
        outFileName = sys.argv[2];
print "Writing output to file %s" % outFileName;

outfh = open(outFileName, 'w');

for i in range(N):
	for j in range(N):
                outfh.write("%s " % mat[i * N + j])
        outfh.write("\n");
