
Sit/Stand Monitor and log

	Uses a teensy to monitor the sit/stand state
	And a mac ioreg call to monitor the active/idle state

	Arduino platformio project is in teensy directory
	Scripts to start the process is in scripts directory

Building the teensy code

	brew install platformio
	platformio install teensy
	cd teensy
	platformio run   		# compiles
	platformio run -t upload	# uploads


3/2014 conceived and programed on windows
5/2019 implemented on mac (awk scripts).  Uploaded to github
