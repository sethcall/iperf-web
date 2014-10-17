###* @jsx React.DOM ###

IPerfForm = React.createClass
  render: ->
    `<form className="iperfForm" onSubmit={this.handleSubmit}>
        <div className="input"><label htmlFor="remote_host">Remote Host</label><input type="text" name="remote_host" ref="remote_host" defaultValue={this.props.remote_ip} placeholder="The IP address or host name to send UDP packets to." /><span className="hint">your IP Address</span></div>
        <div className="input"><label htmlFor="port">Port</label><input type="text" name="port" ref="port"  defaultValue="12000" placeholder="The port of the remote host to send to" onChange={this.handlePortChange}/><span className="hint">port you've opened on your router</span></div>
        <div className="input"><label htmlFor="bandwidth">Bandwidth </label><input type="text" name="bandwidth" ref="bandwidth" defaultValue="1" placeholder="How much bandwidth to send, in Megabits/sec" /><span className="hint">how much bandwidth should we try to send?</span></div>
        <div className="input"><label htmlFor="duration">Duration </label><input type="text" name="duration" ref="duration" defaultValue="10" placeholder="The duration of the test, in seconds." /><span className="hint">how long to send UDP at you?</span></div>
        <div className="input"><label htmlFor="size">Packet Size  </label><input type="text" name="size" ref="size" defaultValue="60" placeholder="The size of the UDP packet" /><span className="hint">how big should the packets be?</span></div>
        <input type="submit" defaultValue="START!" />
      </form>`

  started: (data) ->
    console.log("STARTED", data)

  failedStart: (xhr, status, err) ->
    alert(xhr.responseText)

  handlePortChange: (e) ->
    port = this.refs.port.getDOMNode().value.trim()
    $(document).triggerHandler('ON_PORT_CHANGED', {port:port})

  handleSubmit: (e) ->
    e.preventDefault()
    remote_host = this.refs.remote_host.getDOMNode().value.trim()
    port = this.refs.port.getDOMNode().value.trim()
    size = this.refs.size.getDOMNode().value.trim()
    bandwidth = this.refs.bandwidth.getDOMNode().value.trim()
    duration = this.refs.duration .getDOMNode().value.trim()

    $.ajax({
      url: '/api/iperf/start',
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json',
      processData: false,
      data: JSON.stringify({remote_host: remote_host, port: port, size: size, bandwidth: bandwidth, duration: duration})
      success: this.started,
      error: this.failedStart
    })


  componentDidMount: ->

window.IPerfForm = IPerfForm