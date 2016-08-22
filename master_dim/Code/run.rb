require 'mysql2'
require_relative '/home/ubuntu/keymaster'

dbh  = Mysql2::Client.new(host: ENV['LANNISTER'], username: ENV['ETLDBUSER'], password: ENV['ETLDBPASS'], database: "master_dim", flags: Mysql2::Client::MULTI_STATEMENTS, local_infile: true)
puts ENV['LANNISTER']

jobresults = dbh.query("SELECT COUNT(*) cnt FROM master_dim.lu_ip_block WHERE status = 9 AND NOT start_ip IS NULL;")
jobresults.each do |row|
	$jobcount = row['cnt'].to_int
	#p $jobcount.to_s + " jobs to process."
 	puts Time.now.strftime("%Y-%m-%d_%H:%M:%S") + " - " + $jobcount.to_s + " IP blocks to process."
end
while $jobcount > 0 do
  # Sleep randomly so that concurrent procs don't pull the same job_code
  sleep(rand(100)/50)
  sql = "SELECT start_ip FROM master_dim.lu_ip_block WHERE status = 9 AND NOT start_ip IS NULL order by start_ip asc limit 1;"
  results = dbh.query(sql)
  row = results.first
  start_ip = row['start_ip'].to_s
  puts Time.now.strftime("%Y-%m-%d_%H:%M:%S") + " - process_id: #{Process.pid}; start_ip: " + start_ip
  sql = "CALL master_dim.process_lu_ip_address(" + start_ip + ");"
  rs2 = dbh.query(sql)
  # This is here just to handle the many outputs from the replicate procedure
  while dbh.next_result
       	rs2 = dbh.store_result
  end
  jobresults = dbh.query("SELECT COUNT(*) cnt FROM master_dim.lu_ip_block WHERE status = 9 AND NOT start_ip IS NULL;")
  jobresults.each do |row| 
  	$jobcount = row['cnt'].to_int
  end
end 
dbh.close if dbh

