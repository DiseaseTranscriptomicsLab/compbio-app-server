# Nginx

[Nginx][] is the orchestrator of the server behind-the-scenes and responsible
for the following:

- Reverse proxy (i.e. URL redirection)
- Serve SSL certificates
- [Public](public) folder: all data in this folder is available to be browsed
and downloaded at [/public](https://compbio.imm.medicina.ulisboa.pt/public)

## SSL certificate renewal

SSL certificates are maintained via [Nginx][] for encrypted HTTPS traffic. These
certificates need to be renewed frequently (e.g. every year). To do so:

1. Update the SSL certificate files

2. In case the filename of the SSL certificate changes, open
[`nginx.conf`][nginx.conf] and replace the path to the certificates (in
`ssl_certificate` and `ssl_certificate_key`)

3. Manually restart Nginx with the command `docker-compose restart nginx`

[Nginx]: https://nginx.org
[nginx.conf]: nginx.conf
