# Dockerfile by Marcos Roberto
FROM postgres:9.6

# Fix postgres locale
RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

# Add initial SQL scripts to run on first postgres run
ADD ./sql_scripts/. /docker-entrypoint-initdb.d