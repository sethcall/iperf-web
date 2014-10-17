###* @jsx React.DOM ###

IPerfExample = React.createClass
  render: ->
    `<div>{this.props.windows ? '' : './'}iperf -s -u -i 1 -p {this.state.port}</div>`

  getInitialState: ->
    return {port: 12000}

  onPortChanged: (e, data) ->
    console.log("data", data)
    if data.port? and data.port != ''
      this.setState({port:data.port})
    else
      this.setState({port:'INVALID'})

  componentDidMount: ->
    $(document).on('ON_PORT_CHANGED', this.onPortChanged)




window.IPerfExample = IPerfExample