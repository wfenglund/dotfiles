import requests
import sys
from datetime import datetime
from os import path

file_dir = path.dirname(__file__)

try:
    choice = sys.argv[1]
    if choice == '-setch':
        try:
            checkpoint = sys.argv[2]
            checkpoint = ''.join(filter(str.isdigit, checkpoint))
            if checkpoint == '':
                checkpoint = '0'
            with open('checkpoint.file', 'w') as chckpntfl:
                chckpntfl.writelines(checkpoint)
            print(f'New price checkpoint set to {checkpoint} USD.')
            quit()
        except IndexError:
            print('Please supply a checkpoint.')
            quit()
    if choice == '-h':
        print('Prices the previous five times you asked:')
        with open(file_dir + '/history.file', 'r') as history:
            for line in history:
                line = line.replace('\n', '')
                print(line)
        print()
except IndexError:
    choice = 'nothing'
    pass

response = requests.get('https://api.coindesk.com./v1/bpi/currentprice.json')
data = response.json()
usd_price = data['bpi']['USD']['rate'].replace(',', '')
usd_price = float(usd_price)
usd_price = int(usd_price)

if choice == '-s':
    print(usd_price)
else:
    print(f'The current price for one Bitcoin is {usd_price} USD.')

now = datetime.now()
current_time = now.strftime('%Y-%m-%d %H:%M:%S')

with open(file_dir + '/history.file', 'r+') as history:
    throw = history.readline()
    data = history.read()
    history.seek(0)
    history.write(data)
    history.writelines(f'{usd_price} [{current_time}]\n')
    history.truncate()

if choice == '-c':
    try:
        with open('checkpoint.file', 'r') as chkpntfl:
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
