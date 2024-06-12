##########################
#title:			Sweelinq delay
#copyright:	Elpro BV / Content Organs
#date:			2024 June 11
#
#[tk-tutorial]			https://www.pythontutorial.net/tkinter
#
#########################

import tkinter as tk
from tkinter.messagebox import showerror
import os   # For performing ping command
import time # For sleep()
import sys  # For exiting with return code

PING_TIMEOUT = 30   # In seconds

# handle left mouse click event on waiting window
def waiting_mouse_click(event):
	waiting.destroy()
	sys.exit(2)

# define waiting for wifi message window
def WaitingMessage():
	global waiting
	waiting = tk.Tk()
	waiting.title('Starting Sweelinq')
	window_width  = 300
	window_height = 100
	screen_width  = waiting.winfo_screenwidth() / 2
	screen_height = waiting.winfo_screenheight() / 2
	center_x = int(screen_width / 2 - window_width / 2)
	center_y = int(screen_height / 2 - window_height / 2)
	waiting.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')
	# Add message text
	messagew = tk.Label(waiting, text = "Waiting for Wi-Fi connection...")
	messagew.place(relx = 0.5, rely = 0.5, anchor = 'center')
	# bind event to Window root object
	# (does not work if ping() is called)
	waiting.bind('<Button-1>', waiting_mouse_click)

# define error message window
def FailedMessage():
	global failed
	failed = tk.Tk()
	failed.title('Failed...')
	window_width  = 300
	window_height = 100
	screen_width  = failed.winfo_screenwidth() / 2
	screen_height = failed.winfo_screenheight() / 2
	center_x = int(screen_width / 2 - window_width / 2)
	center_y = int(screen_height / 2 - window_height / 2)
	failed.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')
	# Add message text
	messagef = tk.Label(failed, text = "Failed to make a Wi-Fi connection.\n\nPlease restart your organ.")
	messagef.place(relx = 0.5, rely = 0.5, anchor = 'center')

# Perform ping and destroy window
def ping():
	# Set to False, gets overwritten on ping succes
	global ping_success
	ping_success = False
	loop_counter = 0
	while loop_counter < PING_TIMEOUT:
		response = os.system('ping -c 1 google.com')
		time.sleep(1)
		loop_counter += 1
		if response == 0:
			ping_success = True
			break
	# ping_success will still be False at this point if no succesful ping was
	# performed. Otherwise it will have been set to True
	waiting.destroy()

# Perform ping loop 100ms after root window's main loop has started
WaitingMessage()
waiting.after(100, ping)
waiting.mainloop()

# Check if ping succeeded. If not: show new error pop-up
if ping_success == False:
	FailedMessage()
	failed.mainloop()
	sys.exit(1)
else:
	sys.exit(0)
