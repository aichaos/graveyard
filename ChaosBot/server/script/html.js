// HTML Chat Script

function LogIn () {
	// Logging into Chat.

	// Get the username.
	var name = window.document.login.name.value;

	// Make sure the name is filled in.
	if (name eq "") {
		window.alert ("CKS // Error\n\nYou have to fill in your name!");
	}
	if (name ne "") {
		var loc = "htmlchat#nick=" + nick + "&msg=CONNECT";
		self.window.location = loc;
	}
}

function SendMsg () {
	// Sending a message.

	// Get variables from the form.
	var nick = window.document.chat.nick.value;
	var msg = window.document.chat.msg.value;
}