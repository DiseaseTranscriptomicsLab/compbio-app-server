# Nginx

[Nginx][] is the orchestrator of the server behind-the-scenes and responsible
for the following:

- Reverse proxy (i.e. URL redirection)
- Serve SSL certificates
- Custom HTML page, including 502 error page (shown when [ShinyProxy][] is not
responding)
- [Public](public) folder: all data in this folder is available to be browsed
and downloaded at [/public](https://compbio.imm.medicina.ulisboa.pt/public)

[Nginx]: https://nginx.org
[ShinyProxy]: https://shinyproxy.io

## SSL certificate renewal

SSL certificates are maintained via [Nginx][] for encrypted HTTPS traffic. These
certificates need to be renewed frequently (e.g. every year). To do so:

1. Update the SSL certificate files

2. In case the filename of the SSL certificate changes, open
[`nginx.conf`][nginx.conf] and replace the path to the certificates (in
`ssl_certificate` and `ssl_certificate_key`)

3. Manually restart Nginx with the command `docker-compose restart nginx`

[nginx.conf]: nginx.conf

## Custom HTML pages

Custom HTML pages to be served via Nginx are located in [html](html).

When ShinyProxy is restarting, overloaded or havin other issues communicating
with Nginx, a [custom 502 error page](html/error_50x.html) is shown asking
users to retry refreshing their browsers in a moment. This page can also be
previewed at any time in the following path:
[/error_50x.html](https://compbio.imm.medicina.ulisboa.pt/error_50x.html)

## Public folder

All files and directories in [`public`](public) will be publicly visible
and available to download in the `/public` path of the website.

This can be configured in [public.config](public.conf).
