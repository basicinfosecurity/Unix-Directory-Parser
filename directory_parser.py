#!/usr/bin/python3

import sys
import threading
from queue import Queue

dir_list = list()
extensions = (".png", ".gif",".bmp", ".jpeg", ".jpg", ".ttf", ".woff",".woff2",".mov",".avi",".mp4",".wmv",".mp3",".svg")
# ~ threads = 5
threads = 10
queue_lock = threading.Lock()
line_queue = Queue()

def main():
	for i in range(threads):
		t = threading.Thread(target=manage_queue)
		t.daemon = True
		t.start()
	with open(sys.argv[1], "r") as directories:
		for line in directories:
			line_queue.put(line)
	directories.close()
	
	line_queue.join()
	with open("parsed.list", "w") as parsed:
		for item in dir_list:
			parsed.write(item + "\n")
		parsed.close()	

def manage_queue():
	base = "/"
	with queue_lock:
		while True:
			current_line = line_queue.get()
			tmp = parse_line(base, current_line)
			if tmp != None:
				base = tmp
			line_queue.task_done()

def parse_line(base, line):
	if line.startswith("total"):
		return
	elif line.startswith("/"):
		base = line.rstrip()
		base = base.rstrip(":")
		if base[-1] != "/":
			base+="/"
		if base[:-1] not in dir_list:
			dir_list.append(base)
	else:
		fname = tokenize_line(line)
		if fname == "." or fname == "..":
			return
		if fname.lower().endswith(extensions):
			return
		tmp = base + fname
		if tmp[:-1] not in dir_list:
			dir_list.append(tmp)
	return base

def tokenize_line(line):
	tmp = line.split()
	l = ' '.join(tmp[8:]).rstrip()
	return l	

if __name__ == "__main__":
	exit(main())
