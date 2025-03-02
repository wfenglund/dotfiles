       IDENTIFICATION DIVISION.
         PROGRAM-ID. BTC-PRICE.
      

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BTC-API-FILE
               ASSIGN TO TMP-FILE
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD BTC-API-FILE.
           1 BTC-RECORD PIC X(255).
       
       WORKING-STORAGE SECTION.
           1 TMP-FILE PIC X(24) VALUE "tmp_btc_price_fetch.json".
           1 SHELL-COMMAND1 PIC X(255).
           1 SHELL-COMMAND2 PIC X(255).
           1 JSON-DATA PIC X(255).
           1 PRICE_START PIC 9(2).
           1 PRICE_STOP PIC 9(2).
           1 RAW_PRICE PIC X(255).
           1 CLEAN_PRICE PIC X(13).

       PROCEDURE DIVISION.
      *> Download Bitcoin price info by calling curl from system:
           STRING
               "curl -s -X 'GET' 'https://api.coingecko.com/api/v3/simp"
               "le/price?ids=bitcoin&vs_currencies=usd&include_market_c"
               "ap=true&include_24hr_vol=true&include_24hr_change=true&"
               "include_last_updated_at=true' "
               "-H 'accept: application/json' -o " TMP-FILE
               INTO SHELL-COMMAND1
           END-STRING
           CALL "SYSTEM" USING SHELL-COMMAND1
           END-CALL
      *> Load price info from temporary file into memory:
           OPEN INPUT BTC-API-FILE
           READ BTC-API-FILE INTO JSON-DATA
           CLOSE BTC-API-FILE
      *> Remove temporary Bitcoin price file:
           STRING "rm ./"TMP-FILE INTO SHELL-COMMAND2
           CALL "SYSTEM" USING SHELL-COMMAND2
      *> Strip away text before and after actual dollar price:
           INSPECT JSON-DATA TALLYING PRICE_START FOR CHARACTERS
               BEFORE INITIAL '"usd":'
           ADD 7 TO PRICE_START
           MOVE JSON-DATA(PRICE_START:) TO RAW_PRICE
           UNSTRING RAW_PRICE
               DELIMITED BY ',"usd_market_cap":'
               INTO CLEAN_PRICE
           END-UNSTRING
      *> Print Bitcoin dollar price:
           DISPLAY CLEAN_PRICE
           STOP RUN.
