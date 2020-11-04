#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd


# In[2]:


mem = pd.DataFrame(np.arange(1024), columns=['word'], dtype='int64')


# In[3]:


cache = pd.DataFrame(data=np.zeros((64, 7)), index=np.arange(64), columns=['v', 'tag', 'dirty', 'w0', 'w1', 'w2', 'w3'], dtype='int64')


# In[4]:


def endereco(n):
    b = '{:032b}'.format(n)
    word_offset = int(b[-2:], 2)
    block_offset = int(b[-4:-2], 2)
    index = int(b[-10:-4], 2)
    tag = int(b[:-10], 2)

    return tag, index, block_offset, word_offset


# In[5]:


def busca(n):
    tag, index, bo, wo = endereco(n)

    # endereço da primeira palavra do bloco na memória
    mem_addr = index * 2**2 + tag * 2**6

    # carrega as quatro palavras da memória para o bloco da cache
    cache.iloc[index] = [1, tag, 0, mem.iloc[mem_addr+0]['word'],
                                    mem.iloc[mem_addr+1]['word'],
                                    mem.iloc[mem_addr+2]['word'],
                                    mem.iloc[mem_addr+3]['word']]


# In[6]:


def write_back(index):
    bloco = cache.iloc[index]
    tag = bloco['tag']

    # as 4 palavras do bloco
    w0, w1, w2, w3 = bloco[-4:]

    # endereço na memória da primeira palavra
    mem_addr = index * 2**2 + tag * 2**6

    # atualiza a memória
    mem.loc[mem_addr:mem_addr+3, 'word'] = w0, w1, w2, w3

    # o bloco agora está limpo
    cache.iloc[index]['dirty'] = 0

    return


# In[7]:


def escrita(n, data):
    tag, index, block_offset, word_offset = endereco(n)

    if (cache['v'][index] == 0):
        busca(n)

    if (cache['dirty'][index] == 1):
        write_back(index)

    cache['w'+str(block_offset)][index] = data
    cache['dirty'][index] = 1


# In[8]:


def leitura(n):
    tag, index, bo, wo = endereco(n)
    bloco = cache.iloc[index]
    word = 'w' + str(bo)
    hit = False;

    # é hit
    if (bloco['v'] == 1) and (bloco['tag'] == tag):
        hit = True;
        return bloco[word], hit

    # bloco ocupado, mas não é o que queremos
    if (bloco['v'] == 1) and (bloco['tag'] != tag):

        # bloco limpo, então só busca na memória
        if (bloco['dirty'] == 0):
            busca(n)
            bloco = cache.iloc[index]
            return bloco[word], hit # hit é False

        # bloco sujo, então atualiza a memória e depois busca
        else:
            write_back(index)
            busca(n)
            bloco = cache.iloc[index]
            return bloco[word], hit # hit é False

    # bloco desocupado, então busca na memória
    busca(n)
    bloco = cache.iloc[index]

    return bloco[word], hit # hit é False



# In[9]:


def main():
    import sys
    fin = sys.argv[1]
    fin = fin.strip()
    fout = open("results.txt", 'w')
    original_stdout = sys.stdout
    sys.stdout = fout

    reads, writes, hits, misses, hitrate, missrate, acessos = 0, 0, 0, 0, 0, 0, 0
    saida = []
    f = open(fin)
    for line in f:
        line = line.strip()
        saida.append(line)
        line = line.split(' ')
        n = int(line[0])
        if (len(line) == 3):
            data = int(line[2], 2)
            escrita(n, data)
            writes += 1
            saida.append('W')
        else:
            w, hit = leitura(n)
            reads += 1
            acessos += 1
            if (hit):
                hits += 1
                saida.append('H')
            else:
                misses += 1
                saida.append('M')

    f.close()

    hitrate = hits/acessos
    missrate = misses/acessos

    print('READS: ', reads)
    print('WRITES: ', writes)
    print('HITS: ', hits)
    print('MISSES: ', misses)
    print('HIT RATE: ', hitrate)
    print('MISS RATE: ', missrate)
    print()

    for i in range(0, len(saida), 2):
        print(saida[i], saida[i+1])

    sys.stdout = original_stdout
    fout.close()
main()
