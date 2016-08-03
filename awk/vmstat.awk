# | "nc 172.17.2.100 2003"
#
# expects vmstat data in this format:
#
# procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
# r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
# 0  0      0 192380 315556 1537288    0    0     6    14  116   40  2  1 96  0


/.*[0-9]/{
   # PROCS
   print PREFIX ".vmstat.procs.running " $1 " " systime()
   print PREFIX ".vmstat.procs.blocked " $2 " " systime()

   # MEMORY
   print PREFIX ".vmstat.mem.swapped " $3 " " systime()
   print PREFIX ".vmstat.mem.free " $4 " " systime()
   print PREFIX ".vmstat.mem.buffer " $5 " " systime()
   print PREFIX ".vmstat.mem.cache " $6 " " systime()
   
   # SWAP
   print PREFIX ".vmstat.swap.in " $7 " " systime()
   print PREFIX ".vmstat.swap.out " $8 " " systime()

   # I/O
   print PREFIX ".vmstat.io.blocks_in " $9 " " systime()
   print PREFIX ".vmstat.io.blocks_out " $10 " " systime()

   # SYSTEM
   print PREFIX ".vmstat.sys.interrupts " $11 " " systime()
   print PREFIX ".vmstat.sys.ctxt_switches " $12 " " systime()

   # CPU
   print PREFIX ".vmstat.cpu.user " $13 " " systime()
   print PREFIX ".vmstat.cpu.system " $14 " " systime()
   print PREFIX ".vmstat.cpu.idle " $15 " " systime()
   print PREFIX ".vmstat.cpu.iowait " $16 " " systime()
}

