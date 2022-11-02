FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.9 python3-pip git -y
RUN pip3 install --upgrade pip

RUN pip install torch==1.10.0+cu111 -f https://download.pytorch.org/whl/cu111/torch_stable.html
RUN pip install torch-cluster -f https://data.pyg.org/whl/torch-1.10.0+cu111.html
RUN pip install torch-sparse -f https://data.pyg.org/whl/torch-1.10.0+cu111.html
RUN pip install torch-geometric -f https://data.pyg.org/whl/torch-1.10.0+cu111.html
RUN pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.0+cu111.html
RUN pip install torch-spline-conv -f https://data.pyg.org/whl/torch-1.10.0+cu111.html

#RUN pip install -q git+https://github.com/facebookresearch/esm.git@98017169c5e55388f3fa3b467693d3a162d084fd
ENV CUDA_HOME="/usr/local/cuda-11.1"
ENV FORCE_CUDA="1"
RUN pip install fair-esm[esmfold]
# OpenFold and its remaining dependency
RUN pip install 'dllogger @ git+https://github.com/NVIDIA/dllogger.git'
RUN pip install 'openfold @ git+https://github.com/aqlaboratory/openfold.git@4b41059694619831a7db195b7e0988fc4ff3a307'
RUN pip install -q urllib3==1.23 pandas tabulate biotite biopython
RUN pip install omegaconf


WORKDIR /home/biolib
COPY esmfold_3B_v1.pt /root/.cache/torch/hub/checkpoints/esmfold_3B_v1.pt
COPY esm2_t36_3B_UR50D.pt /root/.cache/torch/hub/checkpoints/esm2_t36_3B_UR50D.pt
COPY esm2_t36_3B_UR50D-contact-regression.pt /root/.cache/torch/hub/checkpoints/esm2_t36_3B_UR50D-contact-regression.pt
COPY run.py run.py