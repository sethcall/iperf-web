###* @jsx React.DOM ###

IPerfStatus = React.createClass
  render: ->
    `<div>{this.state.output}</div>`

  getInitialState: ->
    return {output: 'checking...'}

  ajaxSetState: (data) ->
    this.setState(data);

  ajaxError: (xhr, status, err) ->

    #console.error(this.props.url, status, err.toString());

  loadIperfState: ->
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: this.ajaxSetState,
      error: this.ajaxError,
    });

  componentDidMount: ->
    this.loadIperfState()
    setInterval(this.loadIperfState, 1000)

window.IPerfStatus = IPerfStatus