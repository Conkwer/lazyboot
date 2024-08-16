import re

with open('tools/cfg/time.txt', 'r') as file:
    content = file.read()

# Use regex to find the time pattern
matches = re.findall(r'\d{2}:\d{2}:\d{2}', content)

# Extract minutes and seconds from each match
times = [match[3:8] for match in matches]

# Print or do something with the times
for time in times:
    print(time)
