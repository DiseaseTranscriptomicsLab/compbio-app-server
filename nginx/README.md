# Nginx

[Nginx][] is the orchestrator of the server behind-the-scenes and responsible
for the following:

- Reverse proxy (i.e. URL redirection)
- SSL certificates for encrypted HTTPS traffic
- [Public](public) folder: all data in this folder is available to be browsed
and downloaded at [/public][public]
- [Favicons](favicon)
- Custom HTML pages, including 502 error page (shown when ShinyProxy is not
responding)

[Nginx]: https://nginx.org
[public]: https://compbio.imm.medicina.ulisboa.pt/public

Nginx configuration is scattered along the following `.config` files:

File                                       | Description
-------------------------------------------| ---------------------------
[nginx.conf](nginx.conf)                   | Main configuration
[shinyproxy.conf](shinyproxy.conf)         | ShinyProxy-specific configuration
[location_apps.conf](location_apps.conf)   | Custom URL paths for ShinyProxy apps
[location_utils.conf](location_utils.conf) | Utilities
[favicon.conf](favicon.conf)               | Favicons
[error.conf](error.conf)                   | Custom error page
[public.conf](public.conf)                 | Public folder

## SSL certificate renewal

SSL certificates need to be renewed frequently (e.g. every year). To do so:

1. Update the SSL certificate files

2. In case the filename of the SSL certificate changes, open
[`nginx.conf`](nginx.conf) and replace the path to the certificates (in
`ssl_certificate` and `ssl_certificate_key`)

3. Manually restart Nginx with the command `docker-compose restart nginx`

## Public folder

All files and directories in [`public`](public) will be publicly visible
and available to download in the [`/public`][public] path of the website.

This can be configured in [public.config](public.conf).

[public]: https://compbio.imm.medicina.ulisboa.pt/public

## Favicons

Favicon files are available in [`favicon`](favicon). Nginx serves these
files in multiple standard paths (e.g. [`/favicon.ico`][favicon.ico]) as
instructed in [`favicon.conf`](favicon.conf). ShinyProxy templates directly
include the path to the icons in their HTML:
[`../shinyproxy/templates/fragments/head.html`][shinyproxy-head].

To change the favicons of the website, simply replace the favicon files and
refresh the page. Tools like [Favicon checker][] allow to test the favicons of
a website.

[favicon.ico]: https://compbio.imm.medicina.ulisboa.pt/favicon.ico
[shinyproxy-head]: ../shinyproxy/templates/fragments/head.html
[Favicon checker]: https://realfavicongenerator.net/favicon_checker

## Custom HTML pages

Custom HTML pages served via Nginx are located in [`html`](html).

When ShinyProxy is restarting, overloaded or not properly communicating with
Nginx, a [custom 502 error](html/error_50x.html) is shown warning users that
the server is currently having issues. This page can be previewed at any time
in [/error_50x.html][error_50x.html].

[error_50x.html]: https://compbio.imm.medicina.ulisboa.pt/error_50x.html

