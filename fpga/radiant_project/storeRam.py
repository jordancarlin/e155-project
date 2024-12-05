toWriteTo = open("testcolor.mem", "w")

for i in range(128):
  for j in range(128):
    if (j // 16)%2 == 0:
      toWriteTo.write('001\n') ## 101 is red
    else:
      toWriteTo.write('010\n') ## 010 is blue

toWriteTo.close()
