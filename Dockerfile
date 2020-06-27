FROM itk-base:latest
MAINTAINER Sam Horvath <sam.horvath@kitware.com>

COPY . /multiatlas
RUN mkdir /multiatlas-rel

ENV SEM_GIT_TAG 1788b378ed2e4928cded2bc9ecdc2b37c7f2af5f
RUN git clone --depth 1 git://github.com/Slicer/SlicerExecutionModel.git /SEM && \
    mkdir /SEM-build && \
    cd /SEM-build && \
    cmake \
        -DBUILD_TESTING:BOOL=OFF \
        -DSlicerExecutionModel_USE_UTF8:BOOL=ON \
        -DITK_DIR:PATH=/ITK-build \        
        /SEM && \
    make

WORKDIR /multiatlas-rel
RUN cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DITK_DIR=/ITK-build \
  -DSlicerExecutionModel_DIR=/SEM-build \
  /multiatlas

RUN make

WORKDIR /multiatlas-rel/bin
RUN cp /multiatlas/cli_list.py /multiatlas/cli_list.json /multiatlas-rel/bin
ENTRYPOINT ["python", "./cli_list.py"]