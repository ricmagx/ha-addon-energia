ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    python3 py3-pip py3-wheel \
    build-base python3-dev \
    libffi-dev musl-dev

WORKDIR /app

COPY requirements-docker.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements-docker.txt \
    && apk del build-base python3-dev libffi-dev musl-dev

COPY src/ src/
COPY config/ config/
COPY alembic.ini .
COPY run.sh /run.sh

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
