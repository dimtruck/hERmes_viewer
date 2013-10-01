require_relative 'result.rb'

class DeviceDiskResultStrategy < AbstractStrategy
  attr_accessor :average_metric_list,:detailed_metric_list 

  def initialize(name, test_type, id, config_path = nil)
  
    @average_metric_list = {
      "tps" => [],
      "rd_sec/s" => [],
      "wr_sec/s" => [],
      "avgrq-sz" => [],
      "avgqu-sz" => [],
      "await" => [],
      "svctm" => [],
      "%util" => []
    }

    @detailed_metric_list = {
      "tps" => [],
      "rd_sec/s" => [],
      "wr_sec/s" => [],
      "avgrq-sz" => [],
      "avgqu-sz" => [],
      "await" => [],
      "svctm" => [],
      "%util" => []
    }

    super(name,test_type,id,config_path)
  end 

  def populate_metric(entry, id, start, stop)
    Dir.glob("#{entry}/sysstats.log*").each do |sysstats_file|
      #execute file and get back io results
      p "sar -d -f #{sysstats_file}"
      io_results = `sar -d -f #{sysstats_file}`.split(/\r?\n/)
      io_results.each do |result|
        result.scan(/Average:\s+(\S+)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)\s+(\d+\.?\d+?)$/).map do |device,tps,rd_secs,wr_secs,avgrqsz,avgqusz,await,svctm,util|
          #get device name and then time
          #only use time that's between start and end (in the 24 hour period the time has to be between those 2)
          dev = "#{File.basename(sysstats_file)}-#{device}"
          initialize_metric(@average_metric_list,"tps",dev)
          @average_metric_list["tps"].find {|key_data| key_data[:dev_name] == dev}[:results] = tps
          initialize_metric(@average_metric_list,"rd_sec/s",dev)
          @average_metric_list["rd_sec/s"].find {|key_data| key_data[:dev_name] == dev}[:results] = rd_secs
          initialize_metric(@average_metric_list,"wr_sec/s",dev)
          @average_metric_list["wr_sec/s"].find {|key_data| key_data[:dev_name] == dev}[:results] = wr_secs
          initialize_metric(@average_metric_list,"avgrq-sz",dev)
          @average_metric_list["avgrq-sz"].find {|key_data| key_data[:dev_name] == dev}[:results] = avgrqsz
          initialize_metric(@average_metric_list,"avgqu-sz",dev)
          @average_metric_list["avgqu-sz"].find {|key_data| key_data[:dev_name] == dev}[:results] = avgqusz
          initialize_metric(@average_metric_list,"%util",dev)
          @average_metric_list["%util"].find {|key_data| key_data[:dev_name] == dev}[:results] = avgqusz
          initialize_metric(@average_metric_list,"await",dev)
          @average_metric_list["await"].find {|key_data| key_data[:dev_name] == dev}[:results] = avgqusz
          initialize_metric(@average_metric_list,"svctm",dev)
          @average_metric_list["svctm"].find {|key_data| key_data[:dev_name] == dev}[:results] = avgqusz
        end
      end
    end
  end
end
