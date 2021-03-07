FROM buildpack-deps

ENV RACKET_BASE_URL="http://mirror.racket-lang.org/installers"
ENV RACKET_VERSION="8.0"
ENV RACKET_SRC_FILE="racket-${RACKET_VERSION}-src.tgz"
ENV RACKET_SRC_URL="${RACKET_BASE_URL}/${RACKET_VERSION}/${RACKET_SRC_FILE}"

WORKDIR /racket
RUN echo ${RACKET_SRC_URL}
COPY ${RACKET_SRC_FILE} /racket/${RACKET_SRC_FILE}
RUN tar xvzf ${RACKET_SRC_FILE} && \
    cd racket-${RACKET_VERSION}/src && \
    ./configure && \
    make && \
    make install 

RUN /racket/racket-${RACKET_VERSION}/bin/raco setup
RUN /racket/racket-${RACKET_VERSION}/bin/raco pkg config --scope installation --set catalogs \
    https://download.racket-lang.org/releases/8.0/catalog/ \
    https://racksnaps.defn.io/snapshots/2021/03/06/catalog/

#RUN raco pkg config --set catalogs \
#    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
#    "https://pkg-build.racket-lang.org/server/built/catalog/" \
#    "https://pkgs.racket-lang.org" \
#    "https://planet-compats.racket-lang.org"

RUN /racket/racket-${RACKET_VERSION}/bin/raco pkg install --skip-installed --auto \
    gregor \
    http-easy \
    sql

CMD ["/racket/racket-${RACKET_VERSION}/bin/racket"]

