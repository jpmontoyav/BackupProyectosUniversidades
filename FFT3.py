import numpy as np
from scipy.fft import fft, fftfreq
import scipy.signal as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import os

lda0_corte=1560 #1560-1570#

LDA0=[]
dP=[]
N=[]
T=[]
filtered=[]
flattened=[]

Flattened_FT=[]
Flattened_FT_Filtered=[]
ZF=[]
MAX=[]

cwd=os.getcwd()
os.chdir('./Spectra3')

spectra=os.listdir()
for s in spectra:
    
    data=pd.read_csv(s,sep=',',header=None)
    data2=data.to_numpy()
    
    f=np.where(data2[:,0]>=lda0_corte)[0][0]
    
    LDA0.append(data2[:f,0])     
    
    dP.append(data2[:f,1])
    
    N.append(LDA0[-1].size)
    T.append((LDA0[-1][-1]-LDA0[-1][0])/(LDA0[-1].size))
    
    spectra[spectra.index(s)]=spectra[spectra.index(s)][6:11]
    
os.chdir(cwd)

for i in np.arange(len(spectra)):
    filtered.append(sp.savgol_filter(dP[i],75,1)) #15
    flattened.append(dP[i]-filtered[i])

fig1 =plt.figure('Filtrado')
fig1.suptitle('Espectros filtrados')
for i in np.arange(len(spectra)):   
    ax=fig1.add_subplot(len(spectra),1, i+1)
    ax.set_ylabel(spectra[i])
    plt.plot(LDA0[i],dP[i])
    plt.plot(LDA0[i],flattened[i])
    plt.plot(LDA0[i],filtered[i])
plt.show()

fig2 =plt.figure('Filtrado_selec')
fig2.suptitle('Espectros filtrados (selección)')
for i in np.arange(3):    
    ax=fig2.add_subplot(3,1, i+1)
    ax.set_ylabel(spectra[i])
    plt.plot(LDA0[i],dP[i])
    plt.plot(LDA0[i],flattened[i])
    plt.plot(LDA0[i],filtered[i])
plt.show()


fig3=plt.figure('FFT-dP[AC]')
fig3.suptitle('Transformada de Fourier de rizado')
for i in np.arange(len(spectra)):
    ax=fig3.add_subplot(len(spectra),1, i+1)
    ax.set_ylabel(spectra[i])
    flattened_FT = fft(flattened[i])
    Flattened_FT.append(2.0/N[i] * np.abs(np.abs(flattened_FT)[0:N[i]//2]))
    Flattened_FT_Filtered.append(sp.savgol_filter(Flattened_FT[-1],35,2))
    zf = fftfreq(N[i], T[i])[:N[i]//2]
    ZF.append(zf)
    plt.ylim(0,0.000005)
    plt.xlim(0,3)
    plt.plot(ZF[-1],Flattened_FT[-1],'coral',ZF[-1],Flattened_FT_Filtered[-1],'navy')
    MAX.append(ZF[-1][np.where(Flattened_FT_Filtered[-1]==max(Flattened_FT_Filtered[-1]))[0][0]])
    plt.vlines(MAX[-1],0.00001,0.000026,colors='grey')
plt.show()

fig4=plt.figure('FFT-dP')
fig4.suptitle('Transformada de Fourier de espectro original')
for i in np.arange(len(spectra)):
    ax=fig4.add_subplot(len(spectra),1, i+1)
    ax.set_ylabel(spectra[i])    
    dP_FT = fft(dP[i])
    zf = fftfreq(N[i], T[i])[:N[i]//2]
    plt.ylim(0,0.000005)
    plt.xlim(0.1,3)
    plt.plot(zf,2.0/N[i] * np.abs(np.abs(dP_FT)[0:N[i]//2]))
plt.show()


for i in np.arange(len(spectra)):
    spectra[i]=float(spectra[i])
fig5=plt.figure('Max vs. Index')
fig5.suptitle('Corrimiento del pico de la campana ante extinción de rizado')
plt.plot(spectra,MAX)
plt.show()

# for i in np.arange(len(spectra)):
#     Flattened_FT_Filtered.append(sp.savgol_filter(Flattened_FT,51,1))






# plt.plot(zf,2.0/N * np.abs(np.abs(dP_FT)[0:N//2]))


#plt.plot(zf,2.0/N * np.abs(flattened_FT [0:N//2]))
# mpl.axes.Axes.axvline(LDA0[(np.where(flattened_FT==max(flattened_FT))[0][0])])
#plt.show()


