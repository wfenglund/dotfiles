import requests
import sys
from datetime import datetime
import os.path

# Get path to this script:
file_dir = os.path.dirname(__file__)

# Create history file if it does not exist:
if os.path.isfile(file_dir + '/history.file') == False:
    open(file_dir + '/history.file', 'a').close()

# Process flags:
try:
    choice = sys.argv[1]
    if choice == '-setch':
        try:
            checkpoint = sys.argv[2]
            checkpoint = ''.join(filter(str.isdigit, checkpoint))
            if checkpoint == '':
                checkpoint = '0'
            with open(file_dir + '/checkpoint.file', 'w') as chckpntfl:
                chckpntfl.writelines(checkpoint)
            print(f'New price checkpoint set to {checkpoint} USD.')
            quit()
        except IndexError:
            print('Please supply a checkpoint.')
            quit()
    if choice == '-h':
        print('Prices the previous five times you asked:')
        with open(file_dir + '/history.file', 'r') as history:
            counter = 0
            for line in history:
                counter = counter + 1
                line = line.replace('\n', '')
                if counter < 6:
                    print(line)
                else:
                    break
        print()
except IndexError:
    choice = 'nothing'
    pass

# Get Bitcoin price:
response = requests.get('https://api.coindesk.com./v1/bpi/currentprice.json')
data = response.json()
usd_price = data['bpi']['USD']['rate'].replace(',', '')
usd_price = float(usd_price)
usd_price = int(usd_price)

# Write the price and date to the history file:
now = datetime.now()
current_time = now.strftime('%Y-%m-%d %H:%M:%S')
with open(file_dir + '/history.file', 'r+') as history:
    content = history.read()
    history.seek(0, 0)
    history.write(f'{usd_price} [{current_time}]\n' + content)

# Simplify output if user chose 'simple':
if choice == '-s':
    print(usd_price)
else:
    print(f'The current price for one Bitcoin is {usd_price} USD.')

# Compare price to set checkpoint if user chose 'checkpoint':
if choice == '-c':
    try:
        with open(file_dir + '/checkpoint.file', 'r') as chkpntfl:
            checkpoint = int(chkpntfl.readline())
        percentage = int(usd_price) / checkpoint

        if percentage > 1:
            direction = 'higher'
            percentage = (percentage - 1) * 100
            percentage = round(percentage, 2)
        else:
            direction = 'lower'
            percentage = (1 - percentage) * 100
            percentage = round(percentage, 2)
        print(f'Current price is {percentage}% {direction} than your checkpoint ({checkpoint} USD).')
    except FileNotFoundError:
        print("No checkpoint available. Please set a checkpoint with '-setch'")
