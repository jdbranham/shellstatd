# | "nc 172.17.2.100 2003"
#
# expects vmstat data in this format:
#
# procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
# r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
# 0  0      0 192380 315556 1537288    0    0     6    14  116   40  2  1 96  0


/.*[0-9]/{
   # PROCS
   print "servers." hostname ".vmstat.procs.running " $1 " " systime()
   print "servers." hostname ".vmstat.procs.blocked " $2 " " systime()

   # MEMORY
   print "servers." hostname ".vmstat.mem.swapped " $3 " " systime()
   print "servers." hostname ".vmstat.mem.free " $4 " " systime()
   print "servers." hostname ".vmstat.mem.buffer " $5 " " systime()
   print "servers." hostname ".vmstat.mem.cache " $6 " " systime()
   
   # SWAP
   print "servers." hostname ".vmstat.swap.in " $7 " " systime()
   print "servers." hostname ".vmstat.swap.out " $8 " " systime()

   # I/O
   print "servers." hostname ".vmstat.io.blocks_in " $9 " " systime()
   print "servers." hostname ".vmstat.io.blocks_out " $10 " " systime()

   # SYSTEM
   print "servers." hostname ".vmstat.sys.interrupts " $11 " " systime()
   print "servers." hostname ".vmstat.sys.ctxt_switches " $12 " " systime()

   # CPU
   print "servers." hostname ".vmstat.cpu.user " $13 " " systime()
   print "servers." hostname ".vmstat.cpu.system " $14 " " systime()
   print "servers." hostname ".vmstat.cpu.idle " $15 " " systime()
   print "servers." hostname ".vmstat.cpu.iowait " $16 " " systime()
}

