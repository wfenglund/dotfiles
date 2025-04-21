# import Bio.SeqIO # import Biopython
# import Bio.Align # import Biopython
import sys
import subprocess
import os

# Functions:
def load_fasta_into_dict(fasta_object): # can not handle multiple line sequences
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

def get_longest(in_list):
    char_counts = [len(i) for i in in_list]
    char_counts.sort()
    char_counts.reverse()
    return char_counts[0]

def print_fasta_dict(fasta_dict1, short_names = False, display_offset = 0, snp_only = False):
    fasta_dict = fasta_dict1.copy()
    max_char = get_longest(fasta_dict1.keys())
    max_seql = get_longest(fasta_dict1.values())
    if short_names:
        indexing = 10
    else:
        indexing = max_char
    print_width = os.get_terminal_size()[0] - indexing - 3
    position_list = []
    for h in fasta_dict.keys():
        if len(fasta_dict[h]) < max_seql:
            fasta_dict[h] = fasta_dict[h] + ('-' * (max_seql - len(fasta_dict[h])))
    for i in range(0, max_seql):
        base_holder = ''
        for j in fasta_dict.keys():
            if base_holder == '':
                base_holder = fasta_dict[j][i]
            else:
                if base_holder != fasta_dict[j][i]:
                    position_list = position_list + [i]
                    break
    for k in fasta_dict.keys():
        new_seq = ''
        old_pos = display_offset
        offset_addition = 0
        if snp_only:
            new_seq_list = ['\033[91m' + fasta_dict[k][i] + '\033[0m' for i in range(0, len(fasta_dict[k])) if i in position_list]
        else:
            new_seq_list = ['\033[91m' + fasta_dict[k][i] + '\033[0m' if i in position_list else fasta_dict[k][i] for i in range(0, len(fasta_dict[k]))]
        fasta_dict[k] = ''.join(new_seq_list[display_offset:print_width + display_offset])
    
    for i in fasta_dict.keys():
        display_name = i + (' ' * (max_char - len(i)))
        display_name = display_name.replace('>', '', 1)
        print(f'{display_name[:indexing]} : {fasta_dict[i]}')
    print(f'\nShowing bases {1 + display_offset}-{print_width + display_offset} out of {max_seql}')

def align_fasta_dict(fasta_dict):
    seq_string = ''
    for i in fasta_dict.keys():
        seq_string = seq_string + i + '\n' + fasta_dict[i] + '\n'
    # test = subprocess.run(['clustalw2', '-INFILE=test_sequences.fa', '-QUIET', '-OUTPUT=FASTA', '-OUTFILE=/dev/stderr'], stdout = subprocess.DEVNULL, stderr = subprocess.PIPE)
    # test = subprocess.run(['clustalo', '-i', 'test_sequences.fa'], stdout = subprocess.PIPE)
    test = subprocess.run(['clustalo', '-i', '-'], input = seq_string.encode('ascii'), stdout = subprocess.PIPE)
    aligned_dict = load_fasta_into_dict(test.stdout.decode().split('\n'))
    return aligned_dict

# Input:
fasta_file = sys.argv[1]

# Load fasta file:
# seq_dict = {'>seq1':'AAAAATAGTCAAAAAT', '>seq2':'TTTTTTAAAAATAGTC'}
# with open('test_sequences.fa') as input_fasta:
with open(fasta_file) as input_fasta:
    seq_dict = load_fasta_into_dict(input_fasta)

# Display alignment and take input:
short_names = False
snp_only = False
offset = 0
print_fasta_dict(seq_dict, short_names)
while True:
    user_input = input('\nInput: ')
    print()
    if user_input == 'q':
        break
    elif user_input == 's': # shorten or unshorten names
        if short_names:
            short_names = False
        else:
            short_names = True
    elif user_input == 'snp':
        if snp_only:
            snp_only = False
        else:
            snp_only = True
    elif user_input == 'r': # move along alignment to the right
        offset = offset + 50
    elif user_input == 'l': # move along alignment to the right
        offset = offset - 50
    elif user_input == 'a':
        seq_dict = align_fasta_dict(seq_dict)
    elif user_input.startswith('>'):
        seq_dict[user_input.split()[0]] = user_input.split()[1]
    elif user_input.endswith('.fa') or user_input.endswith('.fasta'):
        with open(user_input, 'w') as output_fasta:
            for i in seq_dict.keys():
                output_fasta.write(i + '\n')
                output_fasta.write(seq_dict[i] + '\n')
    print_fasta_dict(seq_dict, short_names, offset, snp_only)
