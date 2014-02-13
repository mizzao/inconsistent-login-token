if Meteor.isClient
  Template.login.events =
    "submit form.login" : (e, tmpl) ->
      e.preventDefault()
      username = tmpl.find("input[name=username]").value
      Accounts.callLoginMethod
        methodArguments: [{username: username}]

  Template.login.loggedIn = -> Meteor.userId()

  Template.status.events =
    "click .btn-danger": -> Meteor.disconnect()
    "click .btn-success": -> Meteor.reconnect()

  Template.status.connected = -> Meteor.status().connected

if Meteor.isServer
  Accounts.registerLoginHandler (request) ->
    return unless request.username

    user = Meteor.users.findOne
      username: request.username

    unless user
      userId = Meteor.users.insert
        username: request.username
    else
      userId = user._id;

    stampedToken = Accounts._generateStampedLoginToken();

    # Skip the token?
#    Meteor.users.update userId,
#      $push: {'services.resume.loginTokens': stampedToken}

    return {
      id: userId,
      token: stampedToken.token
    }
