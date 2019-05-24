FROM postgres:9.6.2
MAINTAINER dwint-medi

ENV POSTGRES_USER mladmin
ENV POSTGRES_PASSWORD mladmin
# Rename qdata to mldata
ENV POSTGRES_DB mldata

COPY /entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh
COPY dump.dump dump.dump

EXPOSE 80:5432

