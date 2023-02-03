ARG IMAGE_VARIANT=slim-buster
ARG PYTHON_VERSION=3.7.12
ARG OPENJDK_VERSION=8

FROM python:${PYTHON_VERSION}-${IMAGE_VARIANT} AS py3
FROM openjdk:${OPENJDK_VERSION}-${IMAGE_VARIANT}

LABEL Maintainer="noel.john"

WORKDIR /home/spark_kafka
COPY --from=py3 / /
COPY requirements.txt .
RUN pip install -r requirements.txt

RUN apt-get update && apt-get -y install vim

COPY scripts .

#CMD [ "python", "./spark_program.py"]