![](https://img.shields.io/badge/Pure--FTPd-1.0.42-brightgreen.svg) ![](https://img.shields.io/badge/Alpine-3.4-brightgreen.svg) ![](https://img.shields.io/docker/stars/gists/pure-ftpd.svg) ![](https://img.shields.io/docker/pulls/gists/pure-ftpd.svg)

#### Volume

- /home/ftpuser
- /etc/pureftpd

#### Environment:

- LISTEN_PORT
- PUBLIC_HOST

#### Creating an instance:

    docker run -d -p 21:21 -p 30000-30009:30000-30009 -v $(pwd)/pureftpd:/etc/pureftpd -v /your/data:/home/ftpuser gists/pure-ftpd

#### Compose example:

    transmission:
      image: gists/pure-ftpd
      container_name: pure-ftpd
      ports:
        - "21:21"
        - "30000-30009:30000-30009"
      volumes:
        - /your/data:/home/ftpuser
        - ./pureftpd:/etc/pureftpd
      restart: always

##### ftpuser permision

    docker exec -it pure-ftpd chown -R /home/ftpuser

##### ftpuser is OS user, test_user is the FTP virtual user

    docker exec -it pure-ftpd pure-pw useradd test -m -u ftpuser -d /home/ftpuser/test

##### refresh pure-ftpd password file or the new ftp user is unable to login

    docker exec -it pure-ftpd pure-pw mkdb

##### backup pureftpd.passwd

    docker exec -it pure-ftpd cp /etc/pureftpd.passwd /etc/pureftpd/pureftpd.passwd

#### pure-ftpd

```
/usr/sbin/pure-ftpd # path to pure-ftpd executable
-C 10 # --maxclientsperip (no more than 10 requests from the same ip)
-l puredb:/etc/pureftpd.pdb # --login (login file for virtual users)
-E # --noanonymous (only real users)
-j # --createhomedir (auto create home directory if it doesnt already exist)
-R # --nochmod (prevent usage of the CHMOD command)
-P $PUBLIC_HOST # IP/Host setting for PASV support, passed in your the PUBLIC_HOST env var
-p 30000:30009 # PASV port ranges
```