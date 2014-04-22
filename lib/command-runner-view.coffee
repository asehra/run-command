{$, View} = require 'atom'
{CommandRunner} = require './command-runner'

module.exports =
class CommandRunnerView extends View
  @content: ->
    @div class: "inset-panel panel-bottom run-command", =>
      @div class: "panel-heading", =>
        @span 'Command: '
        @span outlet: 'header'
      @div class: "panel-body padded results", =>
        @pre '', outlet: 'results'

  # Tear down any state and detach
  destroy: ->
    delete @commandRunner
    @detach()

  render: (command, results)=>
    @header.text(command)
    @results.text(results)

  hidePanel: =>
    @detach() if @hasParent()

  showPanel: =>
    atom.workspaceView.prependToBottom(this) unless @hasParent()

  togglePanel: =>
    if @hasParent() then @hidePanel() else @showPanel()

  runCommand: (command)->
    delete @commandRunner if @commandRunner?
    @commandRunner = new CommandRunner(command, @render)
    @commandRunner.runCommand()
    @showPanel()

  promptForCommand: (e)=>
    @runCommand "echo Hello World"

  reRunCommand: (e)=>
    if @commandRunner?
      @commandRunner.runCommand()
      @showPanel()
    else
      e.abortKeyBinding()
