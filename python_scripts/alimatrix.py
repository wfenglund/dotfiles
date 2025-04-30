# Libraries:
import sys
import subprocess
import os
import curses
import curses.textpad
import random

# Functions:
def load_fasta_into_dict(fasta_object): # takes a fasta file as input and returns a dictionary of sequences
    alignment_dict = {}
    counter = 1
    for line in fasta_object:
        if(line.startswith('>')):
            seq_name = line.strip()
            counter = 2
        elif counter == 2:
            if seq_name in alignment_dict.keys():
                alignment_dict[seq_name] = alignment_dict[seq_name] + line.strip()
            else:
                alignment_dict[seq_name] = line.strip()
#             counter = 1
    return alignment_dict

def get_longest(in_list): # takes a list and returns the length of the longest item
    char_counts = [len(i) for i in in_list]
    char_counts.sort()
    char_counts.reverse()
    return char_counts[0]

def align_fasta_dict(fasta_dict): # function that takes a dictionary of sequences and returns it aligned
    seq_string = ''
    for i in fasta_dict.keys():
        seq_string = seq_string + i + '\n' + fasta_dict[i] + '\n'
    # test = subprocess.run(['clustalw2', '-INFILE=test_sequences.fa', '-QUIET', '-OUTPUT=FASTA', '-OUTFILE=/dev/stderr'], stdout = subprocess.DEVNULL, stderr = subprocess.PIPE)
    # test = subprocess.run(['clustalo', '-i', 'test_sequences.fa'], stdout = subprocess.PIPE)
    test = subprocess.run(['clustalo', '-i', '-'], input = seq_string.encode('ascii'), stdout = subprocess.PIPE)
    aligned_dict = load_fasta_into_dict(test.stdout.decode().split('\n'))
    return aligned_dict

def print_fasta_dict(app_screen, fasta_dict1, short_names = False, display_offset = 0, snp_only = False): # function that prints an alignment using curses
    fasta_dict = fasta_dict1.copy()
    max_char = get_longest(fasta_dict1.keys())
    max_seql = get_longest(fasta_dict1.values())
    indexing = 10 if short_names else  max_char - 1
    print_width = os.get_terminal_size()[0] - indexing - 3
    position_list = []
    for h in fasta_dict.keys(): # for every seqeuence
        fasta_dict[h] = fasta_dict[h][display_offset:print_width + display_offset] # shorten it to print_width
        if len(fasta_dict[h]) < print_width: # test
            fasta_dict[h] = fasta_dict[h] + ('-' * (print_width - len(fasta_dict[h]))) # extend to print_width if shorter
    for i in range(0, print_width): # for the length of the sequence
        base_holder = ''
        for j in fasta_dict.keys(): # for every base in that position
            if base_holder == '':
                base_holder = fasta_dict[j][i]
            else:
                if base_holder != fasta_dict[j][i]:
                    position_list = position_list + [i] # record if sequences bases differ in this position
                    break
    for i in fasta_dict.keys():
        display_name = i + (' ' * (max_char - len(i)))
        display_name = display_name.replace('>', '', 1)
        app_screen.addstr(display_name[:indexing] + ' : ')
        counter = 0
#         for nucleotide in fasta_dict[i][display_offset:print_width + display_offset]:
        for nucleotide in fasta_dict[i]:
            if counter in position_list: # if position is a snp
                app_screen.addstr(str(nucleotide), curses.color_pair(1)) # make snp red
            else:
                app_screen.addstr(str(nucleotide))
            counter = counter + 1
    app_screen.addstr(f'\nShowing bases {1 + display_offset}-{print_width + display_offset} out of {max_seql}')

def enter_fasta_text(stdscr, seq_dict): # function that opens a text window and parses entered fasta sequences
    term_w, term_h = os.get_terminal_size()
    stdscr.addstr(0, 0, "Enter fasta sequence: (hit Ctrl-g to submit)")
    editwin = curses.newwin(term_h - 3, term_w - 4, 2, 2)
    curses.textpad.rectangle(stdscr, 1, 1, term_h - 1, term_w - 2)
    stdscr.refresh()
    tbox = curses.textpad.Textbox(editwin)
    tbox.edit() # edit Textbox
    fasta_text = tbox.gather() # retrieve text
    name_flag = 0
    for line in fasta_text.split('\n'):
        if(line.startswith('>')):
            new_name = line.strip()
            seq_dict[new_name] = ''
            name_flag = 1
        elif name_flag == 0:
            while True:
                new_name = '>random_seq' + str(random.randint(1, 9999))
                if new_name not in seq_dict.keys():
                    seq_dict[new_name] = line.strip()
                    break
            name_flag = 1
        else:
            seq_dict[new_name] = seq_dict[new_name] + line.strip()
    return seq_dict

def return_on_enter(x):
    if x == 10:
        return 7
    else:
        return x

def make_text_prompt(app_screen, seq_dict, prompt_text):
    term_w, term_h = os.get_terminal_size()
    app_screen.addstr(term_h - 1, 0, prompt_text)
    editwin = curses.newwin(1, term_w - len(prompt_text), term_h - 1, len(prompt_text))
    app_screen.refresh()
    tbox = curses.textpad.Textbox(editwin)
    tbox.edit(return_on_enter) # enter text
    return tbox.gather() # return entered text

def write_to_file(app_screen, seq_dict):
    fasta_name = make_text_prompt(app_screen, seq_dict, 'Enter fasta file to create (or overwrite): ')
    if fasta_name.strip().endswith('.fa') or fasta_name.strip().endswith('.fasta'):
        with open(fasta_name.strip(), 'w') as output_fasta:
            for i in seq_dict.keys():
                output_fasta.write(i + '\n')
                output_fasta.write(seq_dict[i] + '\n')
    else:
        app_screen.addstr(f'ERROR: File name does not end with .fa or .fasta')

def remove_sequence(app_screen, seq_dict):
    seq_ids = {}
    counter = 0
    for seq_name in seq_dict.keys():
        seq_ids[counter] = seq_name
        app_screen.addstr(counter, 0, str(counter) + ': ')
        counter = counter + 1
    sequence_id = make_text_prompt(app_screen, seq_dict, 'Specify sequence to remove: ')
    if int(sequence_id) in seq_ids.keys():
        seq_dict.pop(seq_ids[int(sequence_id)])
    else:
        app_screen.addstr(f'ERROR: Not a valid sequence identifier')
    return seq_dict

def start_application(app_screen): # main program that takes commands and displays the alignment
    curses.use_default_colors()
    for i in range(0, curses.COLORS):
        curses.init_pair(i, i, -1);
    with open(fasta_file) as input_fasta: # load fasta file
        seq_dict = load_fasta_into_dict(input_fasta)
    short_names = False
    offset = 0
    snp_only = False
    while True:
        print_fasta_dict(app_screen, seq_dict, short_names, offset, snp_only)
        character = app_screen.getch()
        app_screen.addstr(str(character))
        if character == 113: # if press q, quit
            break
        elif character == 115: # if press s, shorten names of sequences
            if short_names:
                short_names = False
            else:
                short_names = True
        elif character == 99: # if press c, only show SNPs # not working
            if snp_only:
                snp_only = False
            else:
                snp_only = True
        elif character == 261: # if press right arrow, navigate alignment to the left
            offset = offset + 50
        elif character == 260: # if press left arrow, navigate alignment to the left
            if (offset - 50) >= 0:
                offset = offset - 50
            else:
                offset = 0
        elif character == 97: # if press a, align sequences
            seq_dict = align_fasta_dict(seq_dict)
        elif character == 103: # if press g, enter fasta sequence to add
            enter_fasta_text(app_screen, seq_dict)
        elif character == 62: # if press >, write to file
            write_to_file(app_screen, seq_dict)
        elif character == 82: # if press R, remove specified sequence
            seq_dict = remove_sequence(app_screen, seq_dict)
        elif character == 88: # if press X, remove chunk of alignment # not working properly
            start, stop = 8, 16
            for seq_name in seq_dict.keys():
                seq_dict[seq_name] = seq_dict[seq_name][:start] + seq_dict[seq_name][stop:]
        app_screen.erase()

fasta_file = sys.argv[1] # get input file
curses.wrapper(start_application) # run application
