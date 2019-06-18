FROM cubao/basic as build
ADD . /tmp/code
RUN cd /tmp/code && \
    sudo make clean && \
    sudo mkdir dist && sudo chmod 777 -Rf dist && \
    sudo make install

FROM cubao/basic
ENV USER=conan
COPY --from=build /home/$USER/.cmake_install /home/$USER/.cmake_install 
RUN sudo chown $USER /home/$USER/.cmake_install
