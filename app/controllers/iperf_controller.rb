
class IperfController < ApplicationController

  def index

  end

  def status
    iperf_state = session[:iperf_state]

    if iperf_state
      begin
      iperf_state[:output] = IO.read(iperf_state["output_path"])
      rescue
       puts "UNABLE TO READ FILE #{iperf_state["output_path"]}"
      end
    else
      iperf_state = {output:'No test has been run yet'} if iperf_state.nil?
    end

    render :json => iperf_state
  end

  def start
    iperf_state = session[:iperf_state]

    if !iperf_state.nil?
      puts "IPERF STATE #{iperf_state}"
      started_at = Time.parse(iperf_state["started_at"])
      duration = iperf_state["duration"].to_i

      puts "STARTED AT #{started_at.inspect}"
      if Time.now - started_at < duration + 1
        render :json => {msg: 'Please wait for previous test to finish'}, status: 422
        return
      end
    end

    remote_host = params[:remote_host]
    bandwidth = params[:bandwidth].to_i
    port = params[:port].to_i
    size = params[:size].to_i
    duration = params[:duration].to_i


    if remote_host.blank?
      render :json => {msg: 'Remote Host must be set'}, status: 422
      return
    end

    if bandwidth == 0
      render :json => {msg: 'Bandwidth must be a positive number'}, status: 422
      return
    end

    if port == 0
      render :json => {msg: 'Port must be a positive number'}, status: 422
      return
    end

    if size == 0
      render :json => {msg: 'Size must be a positive number'}, status: 422
      return
    end


    if duration == 0
      render :json => {msg: 'Duration must be a positive number'}, status: 422
      return
    end


    if size > 1500
      render :json => {msg: 'Size must be less than 1500'}, status: 422
      return
    end


    if duration > 60
      render :json => {msg: 'Duration must be less than 60'}, status: 422
      return
    end

    if bandwidth > 15
      render :json => {msg: 'Bandwidth must be less than 15'}, status: 422
      return
    end

    Iperf.start(session, remote_host, "#{bandwidth}m", port, size, duration)

    render :json => {}
  end
end
