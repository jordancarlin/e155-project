toWriteTo = open("blank.mem", "w")

for i in range(128):
  for j in range(128):
    toWriteTo.write('000\n') ## 101 is red

toWriteTo.close()
