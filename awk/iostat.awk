
# expects 'iostat -xm' data in this format:
#
# Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
# sda               0.14     4.55    0.47    2.27     0.01     0.03    24.94     0.01    2.99   0.57   0.15

/^[sd|xvd|bcache]/{
   print PREFIX ".iostat.disk." $1 ".rrqm_persec " $2 " " systime()
   print PREFIX ".iostat.disk." $1 ".wrqm_persec " $3 " " systime()
   print PREFIX ".iostat.disk." $1 ".r_persec " $4 " " systime()
   print PREFIX ".iostat.disk." $1 ".w_persec " $5 " " systime()
   print PREFIX ".iostat.disk." $1 ".MB_read_persec " $6 " " systime()
   print PREFIX ".iostat.disk." $1 ".MB_write_persec " $7 " " systime()
   print PREFIX ".iostat.disk." $1 ".avgrq-sz " $8 " " systime()
   print PREFIX ".iostat.disk." $1 ".avgqu-sz " $9 " " systime()
   print PREFIX ".iostat.disk." $1 ".await " $10 " " systime()
   print PREFIX ".iostat.disk." $1 ".svc_time " $11 " " systime()
   print PREFIX ".iostat.disk." $1 ".percent_util " $12 " " systime()
}

