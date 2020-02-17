
# Disable the lock screen
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'


jarleven@stue:~/opencv/samples/gpu$ nvcc bgfg_segm.cpp -o bgfg_segm `pkg-config --cflags --libs opencv4`



~/.bashrc

#export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export PATH="/usr/local/cuda/bin/:$PATH"



export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}



alias python=python3

