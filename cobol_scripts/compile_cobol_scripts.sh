# Install COBOL (if needed):
# pamac build gnucobol

# Compile individual COBOL scripts:
cobc -free -x -O -o btc-price btc_price.cob
