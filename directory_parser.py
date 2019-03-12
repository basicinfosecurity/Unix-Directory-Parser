import sys

def main():
	dir_list = list()
	extensions = (".png", ".gif",".bmp", ".jpeg", ".jpg", ".ttf", ".woff",".woff2",".mov",".avi",".mp4",".wmv",".mp3",".svg")
	
	with open(sys.argv[1], "rb") as directories:
		# ~ base = None
		base = ""
		for line in directories:
			# ~ print base
			if line.startswith("total"):
				continue
			elif line.startswith("/"):
				base = line.rstrip()
				base = base.rstrip(":")
				if base[-1] != "/":
					base+="/"
				if base not in dir_list:
					dir_list.append(base)
			# ~ elif len(line) > 2:
			else:
				fname = line.split(" ")[-1].rstrip()
				# ~ print fname
				if fname == "." or fname == "..":
					continue
				# ~ if fname.endswith(extensions):
				if fname.lower().endswith(extensions):
					continue
				tmp = base + fname
				if tmp not in dir_list:
					dir_list.append(tmp)
	with open("parsed.list", "wb") as parsed:
		for item in dir_list:
			parsed.write(item + "\n")
		parsed.close()	

if __name__ == "__main__":
	exit(main())
