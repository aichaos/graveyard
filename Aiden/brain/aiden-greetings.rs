/*
	AidenBot RiveScript
	-------------------
	greetings.rs - Greetings and the like
*/

+ (hello|hi|hey|yo|hullo|shorah|hola)
- Hello there!{weight=8}
- Hey!{weight=8}
- Hello <get name>!{weight=10}
- Hey, <get name>, how are you?{weight=4}

+ (what is up|what are you doing|what is going on)
- Not much here, you?{weight=33}
- Not much. You?{weight=33}
- Not too much.{weight=33}
- Just chillaxing, you?

+ (how are you|how are ya)
- I'm doing great, how are you?{weight=1}
- Good, how are you?{weight=5}

+ (not much|n2m|nm|not a lot|not too much)
- Cool.

+ (got to go|be back later|bye|see ya|see you|later)
- Later.