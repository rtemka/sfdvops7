FROM python:3.10.12-alpine3.17 as base

FROM base as builder                                                                                                          

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

                                                                                                                              
RUN mkdir /install                                                                                                            
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev                                                             
WORKDIR /install                                                                                                              
COPY srv/app/requirements.txt /requirements.txt                                                                                       
RUN pip3 install --install-option="--prefix=/install" -r /requirements.txt                                                     
                                                                                                                              
FROM base                                                                                                                     
                                                                                                                              
COPY --from=builder /install /usr/local                                                                                       
COPY . /                                                                                                         
RUN apk --no-cache add libpq                                                                                                  
WORKDIR /

# WORKDIR /
# ADD . /

# RUN apk add build-dep python-psycopg2 && \
#     pip3 wheel --no-cache-dir --no-deps --wheel-dir srv/app/wheels -r srv/app/requirements.txt
# # RUN pip3 install -r /srv/app/requirements.txt

EXPOSE 5000

ENTRYPOINT [ "python", "srv/app/web.py" ]

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends gcc

# COPY requirements.txt .

# FROM python:3.9-slim

# WORKDIR /app

# COPY --from=builder /app/wheels /wheels
# COPY --from=builder /app/requirements.txt .

# RUN pip install --no-cache /wheels/*