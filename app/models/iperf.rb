require 'open3'
require 'tempfile'

class Iperf

  # remote_host = ip or host
  # bandwidth = '1m' for 1 megabit
  # port = 12000 (int)
  # size = 60 (size of packet)
  # duration = 10 (num seconds to run test)
  def self.start(session, remote_host, bandwidth, port, size, duration)

    state = {}
    state[:started_at] = Time.now
    state[:duration] = duration
    session[:iperf_state] = state

    file = Tempfile.new('foo')
    state[:output_path] = file.path

    Thread.new(binding) do

      state[:result] = nil
      state[:pid] = nil

      file.close

      cmd = "iperf -c #{remote_host} -i 1 -u -b #{bandwidth} -p #{port} -l #{size} -t #{duration}"

      Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
        state[:pid] = wait_thr.pid
        while line = stdout_err.gets
          file.open
          file.seek(file.length)
          file.write(line)
          file.close

        end

        exit_status = wait_thr.value

        if exit_status.success?
          puts "IPERF EXITED NORMALLY"
        else
          puts "IPERF FAILED !!! #{cmd}, #{exit_status.inspect}"
        end

        state[:result] = exit_status.success?
      end
    end
  end

end