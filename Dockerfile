ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache python3 py3-pip py3-wheel build-base python3-dev

WORKDIR /app

COPY requirements-docker.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements-docker.txt

COPY src/ src/
COPY config/ config/
COPY alembic.ini .
COPY run.sh /

RUN chmod +x /run.sh

CMD [ "/run.sh" ]
