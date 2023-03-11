# Home Services Docker Compose
A collection of my docker compose specifications that are deployed on my home servers. Compose scripts are found in the Compose directory which contains additional directories for each separate service.

Most docker compose specs are commented such that it's easy for one to understand why the compose spec is built in that way. But they aren't necessarily geared towards being plug and play compatible so they may need tweaking if you wish to use them.

Feel free to make use of these specs.

# Information about the Docker Compose Specs
I try to use linuxserver or bitnami images to save on disk space for images.
To make use of these specs, you may have to manually setup an `ldap` network and `proxy` network. Additionally you may have to setup an LDAP server.